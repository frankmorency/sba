module VendorAdmin
  class MyProfileController < VendorAdminController
    before_action :set_current_organization
    before_action :set_certificates
    before_action :require_vendor_admin_access, except: [:index]
    before_action :require_vendor_admin_access_and_contrubutor

    def index
      @user = current_user
    end
    
    protected

    def require_vendor_admin_access_and_contrubutor
      user_not_authorized  unless can?(:ensure_vendor, current_user) ||  can?(:ensure_contributor, current_user) 
    end
  end
end