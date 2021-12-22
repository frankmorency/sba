module DistrictOfficeSbaSupervisor
  class DashboardController < DistrictOfficeSbaSupervisorController
    include SupervisorAccessRequestsHelper
    include NotificationsHelper
    include SbaWorkload

    def index
      super
      @applications = SbaApplication::MasterApplication.do_supervisor_unassigned_cases(current_user) +
          SbaApplication::EightAAnnualReview.do_supervisor_unassigned_cases(current_user)

      @workload = current_user.workload(:district_office_supervisor)
    end

    def assign
      @applications = []
      app = assigned_application dashboard_params[:application_id].to_i
      @applications << app
      @analyst_duty_stations = DutyStation.find_by(name: app.duty_stations.first.name).users.select{|user| user if user.has_role?(:sba_analyst_8a_district_office)}
      @supervisor_duty_stations = DutyStation.find_by(name: app.duty_stations.first.name).users.select{|user| user if (user.has_role?(:sba_supervisor_8a_district_office) && current_user.id != user.id)}
    end

    def create_assignment
      @applications = []
      @user = User.find(dashboard_params[:user_id].to_i)
      app = assigned_application dashboard_params[:application_id].to_i

      if validate_permissions(@user, app)
        app.start_review_process(@user)

        # some states such as sba_approved have not yet been added to the activity-api
        if app.current_review.workflow_state == 'screening'
          ApplicationController.helpers.log_activity_application_state_change('screening', app.id, current_user.id)
        end
        ApplicationController.helpers.log_activity_application_event('owner_changed', app.id, current_user.id, @user.id)
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

    def assigned_application(id)
      app = []
      [SbaApplication::MasterApplication, SbaApplication::EightAAnnualReview].each do |model|
        app << model.find_by(id: id)
      end
      app.select { |element| !element.nil? }.first
    end

    def dashboard_params
      params.permit(:application_id, :user_id)
    end

    def validate_permissions(user, app)
      # Maybe need to validate also some special conditions on applications
      if user.can?(:ensure_8a_role_district_office)
        return true
      else
        return false
      end
    end

  end
end
