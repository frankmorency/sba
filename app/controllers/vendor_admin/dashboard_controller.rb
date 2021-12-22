module VendorAdmin
  class DashboardController < VendorAdminController
    before_action :set_current_organization

    before_action :require_profile_access, only: :my_profile

    def index
      if current_user.can? :ensure_contributor
        contributor_index
      else
        @results = ProgramParticipation::ResultSet.new(current_organization, current_user)

        @programs = @results.programs
      end
    end

    def my_profile
      @user = current_user
      @certificates = current_organization.displayable_certificates
    end

    private

    def require_profile_access
      user_not_authorized unless (can? :view_personal_profile, current_user) || (can? :view_business_profile, current_user)
    end
  end
end
