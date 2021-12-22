module EightAInitialSbaSupervisor
  class DashboardController < EightAInitialSbaSupervisorController
    include SupervisorAccessRequestsHelper
    include NotificationsHelper
    include Assignable
    include SbaWorkload

    def index
      super
      @applications = SbaApplication::MasterApplication.eight_a.unassigned_cases
      @workload = current_user.workload(:cods_supervisor)
    end

    def assign
      @applications = []
      app = SbaApplication::MasterApplication.find(dashboard_params[:application_id].to_i)
      @applications << app
      get_assignment_users(determine_roles @applications.first)
    end

    def create_assignment
      @applications = []
      @user = User.find(dashboard_params[:user_id].to_i)
      app = SbaApplication::MasterApplication.find(dashboard_params[:application_id].to_i)
      if validate_permissions(@user, app)
        app.start_review_process(@user)
        # some states such as sba_approved have not yet been added to the activity-api
        if app.current_review.workflow_state == "screening"
          ApplicationController.helpers.log_activity_application_state_change("screening", app.id, current_user.id)
        end
        ApplicationController.helpers.log_activity_application_event("owner_changed", app.id, current_user.id, @user.id)
        @applications << app
        if Feature.active?(:notifications)
          if app.is_really_a_review?
            send_notification_to_refered("8(a)", master_application_type(app), "assigned", @user.id, nil, @user.email, app.organization.name, app.case_number)
          else
            send_notification_to_refered("8(a)", master_application_type(app), "assigned", @user.id, app.id, @user.email, app.organization.name)
          end

          if app.is_eight_a_master_application? && app.submitted? && app.has_reconsideration_sections? && app.last_reconsideration_application.submitted?
            send_application_reconsideration_responded("8(a)", master_application_type(app), @user.id, app.id, @user.email, app.organization.name)
          end
        end
      end
      @applications
    end

    private

    def dashboard_params
      params.permit(:application_id, :user_id)
    end

    def validate_permissions(user, app)
      # Maybe need to validate also some special conditions on applications
      if user.can?(:ensure_8a_user_cods) || user.has_role?(:sba_supervisor_8a_hq_program)
        return true
      else
        return false
      end
    end
  end
end
