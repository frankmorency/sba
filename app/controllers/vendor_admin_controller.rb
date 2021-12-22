class VendorAdminController < ApplicationController
  before_action :authenticate_user!
  before_filter :require_vendor_admin_access

  def require_vendor_admin_access
    unless can?(:ensure_vendor, current_user) || (can? :ensure_contributor, current_user)
      user_not_authorized
    end
  end


  protected
  
  def set_certificates
    @certificates = current_organization.displayable_certificates
  end
end