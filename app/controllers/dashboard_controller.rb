class DashboardController < VendorAdminController
  before_action :set_current_organization
  before_action :set_certificates

  before_action :require_profile_access, only: :my_profile

  def index
    @applications = current_organization.current_sba_applications.for_display
    @documents = current_organization.documents.where(" user_id = ?", current_user.id).order(:updated_at).reverse_order.limit(5)
  end

  def my_profile
    @user = current_user
  end

  private

  def require_profile_access
    user_not_authorized unless (can? :view_personal_profile, current_user) || (can? :view_business_profile, current_user)
  end
end
