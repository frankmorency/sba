module Reviews
  class InitiateAdverseActionController < BaseController
    include Wicked::Wizard
    include NotificationsHelper

    steps :adverse_action, :hq_supervisor, :documents_analysis, :add_a_note, :review, :finish

    def show
      @adverse_action = params.dig(:adverse_action)&.to_sym
      set_adverse_action_title

      case step
        when :adverse_action
          delete_session_variables
        when :hq_supervisor
          if session[:adverse_action] == "recommended_voluntary_withdrawal"
            if @current_user.roles_map.to_s.include?("analyst")
              @supervisors = [{"DISTRICT_OFFICE"=>{"8a"=>["supervisor"]}}]
              selected_user_roles = "users.roles_map::text LIKE '%DISTRICT_OFFICE%8a%supervisor%'"
            else
              @supervisors = [{"DISTRICT_OFFICE_DIRECTOR" => {"8a" => ["supervisor"]}}, {"DISTRICT_OFFICE_DEPUTY_DIRECTOR" => {"8a" => ["supervisor"]}}]
              selected_user_roles = "users.roles_map::text LIKE '%DISTRICT_OFFICE%DIRECTOR%8a%supervisor%'"
            end
          else
            @analysts = [{"HQ_PROGRAM"=>{"8a"=>["analyst"]}}, {"HQ_CE"=>{"8a"=>["analyst"]}}]
            @supervisors = [{"HQ_PROGRAM"=>{"8a"=>["supervisor"]}}, {"HQ_CE" => {"8a" => ["supervisor"]}}]
            selected_user_roles = "users.roles_map::text LIKE '%HQ_PROGRAM%8a%' OR users.roles_map::text LIKE '%HQ_AA%8a%supervisor%' OR users.roles_map::text LIKE '%HQ_CE%8a%'"
          end
          @list_users = User.where(selected_user_roles).order(:first_name, :last_name).group_by { |u| u.roles_map }
        when :review, :finish
          unless session[:individual_id]
            flash[:error] = 'Your session timed out. Please try again.'
            jump_to(:adverse_action)
          end
          set_reassign_to
      end

      render_wizard
    end

    def update
      set_session_variables
      case step
        when :review
          set_reassign_to
          # Create note
          note = Note.create!(notated_id: @sba_application.id, notated_type: @sba_application.class.to_s, title: session[:note_subject], body: session[:note_message], author_id: current_user.id, published: true, tags: session[:note_tags])
          ApplicationController.helpers.log_activity_application_event('note_created', @sba_application.id, current_user.id, note.id)
          # Re-assign to HQ supervisor
          @review.reassign_to(@reassign_to)
          ApplicationController.helpers.log_activity_application_event('owner_changed', @sba_application.id, current_user.id, @reassign_to.id)

          if @sba_application.is_really_a_review?
            send_notification_to_refered("8(a)", master_application_type(@sba_application), "assigned", @reassign_to.id, nil, @reassign_to.email, nil, @sba_application.case_number)
          else
            send_notification_to_refered("8(a)", master_application_type(@sba_application), "assigned", @reassign_to.id, @sba_application.id, @reassign_to.email)
          end

          # Create new document
          unless session[:analysis_document].nil?
            create_analysis_letter
          end
          # Update review status
          new_state = session[:adverse_action] + '!'
          @review.send(new_state)
          @review.save!
          record_recommendation(@sba_application, current_user, 'recommendation', session[:adverse_action])
          log_activity
        when :finish
          delete_session_variables
      end
      redirect_to wizard_path(@next_step, adverse_action: session[:adverse_action])
    end

    private

    def record_recommendation(application, evaluator, category, value)
      EvaluationHistory.new.record_evaluation_event(application, evaluator, category, value)
    end

    def set_reassign_to
      @reassign_to = User.where(id: session[:individual_id]).first
    end

    def set_adverse_action_title
      return if params[:adverse_action].blank?
      case session[:adverse_action]
        when 'recommended_early_graduation'
          @adverse_action_title = 'Early graduation'
        when 'recommended_termination'
          @adverse_action_title = 'Send termination to HQ'
        when 'recommended_voluntary_withdrawal'
          @adverse_action_title = 'Voluntary withdrawal'
      end
    end

    def log_activity
      state_change = nil

      case session[:adverse_action]
        when 'recommended_early_graduation'
          state_change = 'recommended_early_graduation'
        when 'recommended_termination'
          state_change = 'recommended_termination'
        when 'recommended_voluntary_withdrawal'
          state_change = 'recommended_withdrawal'
      end

      unless state_change.nil?
        ApplicationController.helpers.log_activity_application_state_change(state_change, @sba_application.id, current_user.id)
      end
    end

    def invalid_note_params?
      params[:note_subject].nil? || params[:note_subject].blank? || params[:note_message].nil? || params[:note_message].blank? || params[:note_tags].nil? || params[:note_tags].blank?
    end

    def set_session_variables
      session[:adverse_action] = params[:adverse_action] if params[:adverse_action].present?
      session[:individual_id] = params[:individual_id] if params[:individual_id].present?
      session[:analysis_document] = params[:analysis_document] if params[:analysis_document].present?
      session[:note_subject] = params[:note_subject] if params[:note_subject].present?
      session[:note_message] = params[:note_message] if params[:note_message].present?
      session[:note_tags] = params[:note_tags] if params[:note_tags].present?
    end

    def delete_session_variables
      session.delete(:adverse_action)
      session.delete(:individual_id)
      session.delete(:analysis_document)
      session.delete(:note_subject)
      session.delete(:note_message)
      session.delete(:note_tags)
    end
  end
end
