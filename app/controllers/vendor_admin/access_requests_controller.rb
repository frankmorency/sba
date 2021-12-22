module VendorAdmin
  class AccessRequestsController < VendorAdminController
    before_action :set_current_organization
    before_action :set_certificates
    before_action :set_request, except: :index

    include RespondAccessRequestsHelper

    def index
      AccessRequest.expire_requests
      result_list = @organization.access_requests.where(type: 'VendorProfileAccessRequest')
      if result_list.blank?
        @access_requests = [VendorProfileAccessRequest.new]
      else
        @access_requests = @organization.access_requests.where(type: 'VendorProfileAccessRequest').joins(:user, :organization).sba_search(
            params[:search_input],
            page: params[:page],
            sort: {
                column: params[:sort],
                direction: sort_direction
            }).to_a
      end
    end

    def accept
      super
      redirect_to vendor_admin_access_requests_path
    end

    def revoke
      super
      redirect_to vendor_admin_access_requests_path
    end

    def reject
      super
      redirect_to vendor_admin_access_requests_path
    end
  end
end
