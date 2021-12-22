# This controller is for when a Federal Contracting Officer make a request to a vendor to be able to view a vendor application
# I think it would be a bit better if this was namespaced or re-named to be a bit more descriptive.
module VendorAdmin
  class RoleAccessRequestsController < VendorAdminController
    before_action :require_vendor_admin_access, except: [:new, :create, :search]
    before_action :validate_agreement, only: :create
    before_action :set_current_organization, except: [:create, :new, :search]
    before_action :set_request, only: [:accept, :revoke, :reject]

    include RequestAccessRequestsHelper
    include RespondAccessRequestsHelper

    def index
      super
      list = @organization.access_requests.where(type: 'VendorRoleAccessRequest')
      if list.blank?
        @access_requests = [VendorRoleAccessRequest.new]
      else
        @access_requests = list.joins(:user, :organization, :role).sba_search(
          params[:search_input],
          page: params[:page],
          sort: {
            column: params[:sort],
            direction: sort_direction
          })
      end
    end

    def new
      @role = params[:role] || "vendor_editor"
    end

    def create
      ac_params = access_request_params
      ac_params[:user_id] = current_user.id
      access_request = VendorRoleAccessRequest.new(ac_params)
      respond_to do |format|
        role_name = 'vendor_editor'
        role_name = Role.find(access_request_params['role_id']).name unless access_request_params['role_id'].blank?
        if access_request.request!(access_request_params)
          format.html { redirect_to new_vendor_admin_role_access_request_path(role: role_name), notice: 'Access Request was successfully created.' }
        else
          format.html { redirect_to new_vendor_admin_role_access_request_path(role: role_name) , notice: 'Your access request was not sent.'}
        end
      end
    end

    def search
      super
      if @organization.nil?
        render json: {id: nil}, :status => 200
      else
        render json: {id: @organization.id, name: @organization.name, duns_number: @organization.duns_number, role_id: @role_id}, :status => 200
      end
    end

    def accept
      super
      redirect_to vendor_admin_role_access_requests_path
    end

    def revoke
      super
      redirect_to vendor_admin_role_access_requests_path
    end

    def reject
      super
      redirect_to vendor_admin_role_access_requests_path
    end

    private

      def validate_agreement
        unless params["request"] == "agreement"
          respond_to do |format|
            format.html { redirect_to new_vendor_admin_role_access_request_path, notice: 'You must accept the conditions for us to be able to submit your request.' }
          end
        end
      end

      def access_request_params
        params.require(:access_request).permit(:role_id)
      end
  end
end
