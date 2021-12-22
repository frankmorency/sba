module Reviews
  class ReassignCaseController < BaseController
    include Wicked::Wizard
    include NotificationsHelper
    include Assignable

    before_action :ensure_user_can_assign_case

    steps :assign, :select_from_another, :finish, :add_a_note, :note_confirmation

    def show
      case step
        when :assign
          session.delete(:duty_station_id)
          get_assignment_users(determine_roles @sba_application)
        when :select_from_another
          @duty_station = DutyStation.find_by_id(session[:duty_station_id])
          @users_outside_ds = User.filter_by_duty_stations_and_roles([@duty_station.name], ['sba_supervisor_8a_district_office', 'sba_analyst_8a_district_office', 'sba_director_8a_district_office', 'sba_deputy_director_8a_district_office']) if @duty_station
        when :finish
          @new_case_owner = @review.current_owner
        when :note_confirmation
          session.delete(:duty_station_id)
      end
      render_wizard
    end

    def update
      case step
        when :assign
          unless params[:user_id] == 'another'
            get_and_reassign_user(params[:user_id])
            jump_to(:finish)
            render_wizard @review
          else
            session[:duty_station_id] = params[:new_district_office]
            jump_to(:select_from_another)
            render_wizard
          end
        when :select_from_another
          get_and_reassign_user(params[:user_id])
          render_wizard @review
        when :add_a_note
          if invalid_note_params?
            flash.now[:error] = 'Please make sure you have filled in all required fields.'
            render_wizard
          else
            create_note params[:note_subject], params[:note_message], params[:note_tags]
            if @note.save!
              render_wizard @note
            else
              flash.now[:error] = 'There was an error saving your note. Please try again.'
              render_wizard
            end
          end
        else
          render_wizard
      end
    end

    private

    def referral_params
      params.require(:referral).permit(:office_id, :individual_id)
    end

    def get_and_reassign_user user_id
      @new_case_owner_and_reviewer = User.find(user_id)
      @review.reassign_to(@new_case_owner_and_reviewer)
      ApplicationController.helpers.log_activity_application_event('owner_changed', @sba_application.id, current_user.id, @new_case_owner_and_reviewer.id)

      if @sba_application.is_really_a_review?
        send_notification_to_refered("8(a)", master_application_type(@sba_application), "assigned", @new_case_owner_and_reviewer.id, nil, @new_case_owner_and_reviewer.email, nil, @sba_application.case_number)
      else
        send_notification_to_refered("8(a)", master_application_type(@sba_application), "assigned", @new_case_owner_and_reviewer.id, @sba_application.id, @new_case_owner_and_reviewer.email)
      end

      if @sba_application.is_eight_a_master_application? && @sba_application.submitted? && @sba_application.has_reconsideration_sections? && @sba_application.last_reconsideration_application.submitted?
        send_application_reconsideration_responded("8(a)", master_application_type(@sba_application), @new_case_owner_and_reviewer.id, @sba_application.id, @new_case_owner_and_reviewer.email, @sba_application.organization.name)
      end
    end

  end
end
