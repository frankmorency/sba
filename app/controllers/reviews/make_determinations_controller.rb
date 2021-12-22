module Reviews
	class MakeDeterminationsController < BaseController
    before_action :ensure_sba_aa_deputy

    include Wicked::Wizard
    include NotificationsHelper

    steps :decision, :upload_letters, :reassign_case, :add_a_note, :compose_message, :review, :done

    def show
      case step
        when :upload_letters
          @determination = EightADetermination.new
          session.delete(:determination_document) unless session[:determination_document].nil?
          session.delete(:analysis_document) unless session[:analysis_document].nil?
        when :reassign_case
          @determination = EightADetermination.new(determination_params)
          cods_supervisors = User.with_role(:sba_supervisor_8a_cods)

          if @determination.determine_eligible == 'true' && @sba_application.duty_station_id
            duty_station = DutyStation.find(@sba_application.duty_station_id)
            do_supervisors = User.filter_by_duty_stations_and_roles([duty_station.name], ['sba_supervisor_8a_district_office'])
            @users = cods_supervisors + do_supervisors
          else
            @users = cods_supervisors
          end
        when :review
          @determination = EightADetermination.new(determination_params)
        when :compose_message
          @determination = EightADetermination.new(determination_params)
          @determination.deliver_to = @sba_application.organization.owner_name
        when :done
          @review.determine(EightADetermination.new(determination_params))
          @determination = EightADetermination.new(determination_params)
          if Feature.active?(:notifications)
            if @sba_application.is_really_a_review?
              send_notification_to_refered("8(a)", master_application_type(@sba_application), "review", @determination.individual.id, nil, @determination.individual.email, @sba_application.organization.name, @sba_application.case_number)
            else
              send_notification_to_refered("8(a)", master_application_type(@sba_application), "review", @determination.individual.id, @sba_application.id, @determination.individual.email, @sba_application.organization.name)
            end
          end
        else
          @determination = EightADetermination.new
      end
      render_wizard
    end

    def update
      @determination = EightADetermination.new(determination_params) unless step == :compose_message
      case step
        when :add_a_note
          session[:determination_subject] = params[:note_subject]
          session[:determination_message] = params[:note_message]
          session[:determination_tags] = params[:note_tags]
        when :compose_message
          @determination = EightADetermination.new(master_app_determination_official_letter_params)
          session[:subject] = master_app_determination_official_letter_params[:subject]
          session[:message] = master_app_determination_official_letter_params[:message]
          session[:individual_id] = master_app_determination_official_letter_params[:individual_id]
        when :review
          # this has to run before a reconsideration section is created
          record_determination(@sba_application, current_user, 'determination', @determination.decision.downcase)

          # NOTE: no more redetermination so subapplication is not created
          # if current_user.can_any?(:trigger_reconsideration) && @determination.determine_eligible == "false"
          #   reconsideration_sections = @sba_application.sections.where(type: 'Section::ReconsiderationSection').select{|s| s.sub_application.submitted?}
          #   create_reconsideration(reconsideration_sections.count)
          #   @sba_application.reopen!(true)
          # end

          create_note session[:determination_subject], session[:determination_message], session[:determination_tags]
          session.delete(:determination_subject)
          session.delete(:determination_message)
          session.delete(:determination_tags)

          unless session[:determination_document].nil?
            create_determination_letter
            session.delete(:determination_document)
          end

          unless session[:analysis_document].nil?
            create_analysis_letter
            session.delete(:analysis_document)
          end

          if Feature.active?(:notifications)
            @determination = EightADetermination.new(determination_params)
            @determination.subject = session[:subject]
            @determination.message = session[:message]
            send_official_message(@determination, current_user, @sba_application.vendor_admin_user, @sba_application)
            session.delete(:subject)
            session.delete(:message)
            session.delete(:individual_id)
          end

          if @determination.determine_eligible == 'true'
            ApplicationController.helpers.log_activity_application_state_change('determined_eligible', @sba_application.id, current_user.id)
          else
            ApplicationController.helpers.log_activity_application_state_change('determined_ineligible', @sba_application.id, current_user.id)
          end
      end
      redirect_to wizard_path(@next_step,
                              eight_a_determination: {determine_eligible: @determination.determine_eligible,
                                                      determine_eligible_for_appeal: @determination.determine_eligible_for_appeal,
                                                      individual_id: @determination.individual_id})
    end

    private

    def record_determination(application, evaluator, category, value)
      EvaluationHistory.new.record_evaluation_event(application, evaluator, category, value)
    end

    def master_app_determination_official_letter_params
      params.permit(:subject, :deliver_to, :message, :individual_id, :determine_eligible, :determine_eligible_for_appeal)
    end

    def determination_params
      params.require(:eight_a_determination).permit(:determine_eligible, :determine_eligible_for_appeal, :individual_id)
    end

    def create_reconsideration(submitted_reconsiderations_count)
      reconsideration = Reconsideration.new({topic: "RECONSIDERATION", message_to_firm_owner: "Reconsiderationing", })
      section_name = reconsideration.unique_name
      section = Section.where(sba_application_id: @sba_application.id).find_by(name: 'eight_a_master')
      position = section.children.count + 1
      reconsideration_questionnaire = Questionnaire.find_by(name: "reconsideration_attachment")
      count = submitted_reconsiderations_count + 1
      display = (count == 1) ? '' : count

      s = Section::ReconsiderationSection.create! name: "#{section_name}_content",
                                                  title: "Reconsideration #{display}",
                                                  position: position,
                                                  submit_text: 'Save and continue',
                                                  parent: section,
                                                  questionnaire: reconsideration_questionnaire,
                                                  related_to_section: nil,
                                                  sba_application: @sba_application,
                                                  status: Section::NOT_STARTED,
                                                  sub_questionnaire: reconsideration_questionnaire

      s.create_reconsideration_app(reconsideration, reconsideration_questionnaire) if s
    end
  end
end
