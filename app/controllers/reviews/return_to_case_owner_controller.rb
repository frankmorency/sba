module Reviews
  class ReturnToCaseOwnerController < BaseController
    include NotificationsHelper

    def index
      case_owner = @review.case_owner
      business_unit = OfficeLocation.find_by(user: case_owner)&.business_unit&.name
      @review.refer_to_new_reviewer(case_owner, business_unit)
      ApplicationController.helpers.log_activity_application_event('reviewer_changed', @sba_application.id, current_user.id, case_owner.id)
      flash[:success] = 'This case was returned to the case owner'
      redirect_to request.referer || root_path
    end
  end
end
