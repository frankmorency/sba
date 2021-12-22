module Reviews
  class ReferCaseWithinSbaController < BaseController
    include Wicked::Wizard
    include NotificationsHelper

    steps :refer_to, :firm_district_office, :other_district_office, :other_district_office_users, :size_review, :district_counsel, :inspector_general, :hq_program, :continuing_eligibility, :add_a_note, :review, :finish

    def show
      @refer_to = params.dig(:refer_to)&.to_sym

      case previous_step
        when :refer_to # jump to the next step based on first screen selection
          jump_to(@refer_to)
        when @refer_to # jump to add_a_note after branch step
          jump_to(:add_a_note) unless @refer_to == :other_district_office
        when :other_district_office_users
          jump_to(:add_a_note)
      end

      case step
        when :refer_to
          delete_session_variables
        when :firm_district_office
          @list_users = User.where("users.roles_map::text LIKE '%DISTRICT_OFFICE%8a%'").where(id: duty_station_users(app_duty_station_id))
        when :other_district_office
          @district_offices = DutyStation.all.order(:name)
        when :other_district_office_users
          @list_users = User.where("users.roles_map::text LIKE '%DISTRICT_OFFICE%8a%'").where(id: duty_station_users(session[:duty_station_id]))
        when :size_review
          @list_users = User.where("users.roles_map::text LIKE '%SIZE%8a%'")
        when :district_counsel
          @list_users = User.where("users.roles_map::text LIKE '%HQ_LEGAL%8a%'")
        when :inspector_general
          @list_users = User.where("users.roles_map::text LIKE '%OIG%8a%'")
        when :hq_program
          @list_users = User.where("users.roles_map::text LIKE '%HQ_PROGRAM%8a%'")
        when :continuing_eligibility
          @list_users = User.where("users.roles_map::text LIKE '%HQ_CE%8a%'")
        when :add_a_note
          # go back to other_district_office if supervisor was not found for selected duty_station
          unless session[:individual_id]
            flash[:error] = 'No supervisor was not found for that district office'
            jump_to(:other_district_office)
          end
        when :review, :finish
          set_referral_instance
      end

      render_wizard
    end

    def update
      set_session_variables
      case step
        when :other_district_office
          session[:duty_station_id] = params.dig(:duty_station_id)
        when :review
          set_referral_instance
          note = Note.create!(notated_id: @sba_application.id, notated_type: @sba_application.class.to_s, title: session[:refer_subject], body: session[:refer_message], author_id: current_user.id, published: true, tags: session[:refer_tags])
          ApplicationController.helpers.log_activity_application_event('note_created', @sba_application.id, current_user.id, note.id)
          @review.refer_to_new_reviewer(@referral, @business_unit)
          ApplicationController.helpers.log_activity_application_event('reviewer_changed', @sba_application.id, current_user.id, @referral.id)

          if @sba_application.is_really_a_review?
            send_notification_to_refered("8(a)", master_application_type(@sba_application), 'assigned', @referral.id, nil, @referral.email, @business_unit.name, @sba_application.case_number)
          else
            send_notification_to_refered("8(a)", master_application_type(@sba_application), 'assigned', @referral.id, @sba_application.id, @referral.email, @business_unit.name)
          end
        when :finish
          delete_session_variables
      end
      redirect_to wizard_path(@next_step, refer_to: session[:refer_to])
    end

    def set_referral_instance
      case session[:refer_to]
        when 'firm_district_office'
          business_title = 'DISTRICT_OFFICE'
        when 'other_district_office'
          business_title = 'DISTRICT_OFFICE'
        when 'size_review'
          business_title = 'SIZE'
        when 'district_counsel'
          business_title = 'HQ_LEGAL'
        when 'inspector_general'
          business_title = 'OIG'
        when 'hq_program'
          business_title = 'HQ_PROGRAM'
        when 'continuing_eligibility'
          business_title = 'HQ_CE'
      end
      @business_unit = BusinessUnit.where(name: business_title).first
      @referral = User.where(id: session[:individual_id]).first
    end

    private

    def invalid_note_params?
      params[:note_subject].nil? || params[:note_subject].blank? || params[:note_message].nil? || params[:note_message].blank? || params[:note_tags].nil? || params[:note_tags].blank?
    end

    def set_session_variables
      session[:refer_to] = params[:refer_to] if params[:refer_to].present?
      session[:duty_station_id] = params[:duty_station_id] if params[:duty_station_id].present?
      session[:individual_id] = params[:individual_id] if params[:individual_id].present?
      session[:refer_subject] = params[:note_subject] if params[:note_subject].present?
      session[:refer_message] = params[:note_message] if params[:note_message].present?
      session[:refer_tags] = params[:note_tags] if params[:note_tags].present?
    end

    def delete_session_variables
      session.delete(:refer_to)
      session.delete(:duty_station_id)
      session.delete(:individual_id)
      session.delete(:refer_subject)
      session.delete(:refer_message)
      session.delete(:refer_tags)
    end

    def duty_station_users(duty_station_id)
      Office.where(duty_station_id: duty_station_id).pluck(:user_id)
    end

    def app_duty_station_id
      @sba_application.duty_stations.pluck(:duty_station_id)
    end
  end
end
