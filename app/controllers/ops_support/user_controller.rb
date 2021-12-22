module OpsSupport
  class UserController < OpsSupportController
    skip_load_and_authorize_resource
    before_action :require_search

    def index
      @user_type = params[:user_type]
      @users = User.ops_support_search(params[:ops_query].strip, params[:user_type]).
      sba_search(params[:search_input], page: params[:page], sort: {column: params[:sort], direction: sort_direction}) unless (params[:ops_query].blank? || params[:ops_query].nil? || !['gov_user','vendor_user'].include?(params[:user_type]))
    end

    def desassociate_organization
      user = User.find(user_id_params)
      ar = VendorAccessRequest.find_by_id(access_request_params["access_request_id"])
      if ar # in case for some reason we don't have an AR
        organization = ar.organization
        # Update the AccessRequest

        ar.update_attributes!(status: "revoked")

        # This may need to be changed when we introduce new roles for vendors
        user.roles_map = nil
        user.save!

        # Check if there are multiple AccessRequest active
        accepted_ars = user.access_requests.select{ |ar| ar.status == "accepted" }
        ars = accepted_ars.select{ |ar| ar.organization_id == organization.id }

        if ars.empty? # if no multiple AccessRequest active disociate org
          user.organizations.destroy(organization)
        end
      else
        user.remove_role(user.roles.first)
        user.organizations.destroy(user.organizations.first )
      end
      redirect_to ops_support_user_path(user)
    end

    # For ops_support users who need to reset a user's passphrase
    def reset
      new_passphrase = params[:reset_passphrase_input]
      user = User.find(user_id_params)
      flash[:error] = "FYI: could not find the record with email. '#{user.email}'" unless user.present?
      unless (flash[:error])
        user.reset_password(new_passphrase, new_passphrase)
        user.confirmed_at = Time.now
        flash[:success] ="You have successfully reset the password! <br \>Email: #{user.email}. <br \>Password: #{new_passphrase}"
      end
      redirect_to ops_support_user_path(user)
    end

    def show
      @user = User.find(user_params)
    end

    private

    def sort_column
      User.sort_column(params[:sort])
    end

    def require_search
      user_not_authorized unless current_user.can? :view_search
    end

    protected

    def user_params
      params.require(:id)
    end

    def user_id_params
      params.require(:user_id)
    end

    def access_request_params
      params.permit(:access_request_id)
    end

  end
end
