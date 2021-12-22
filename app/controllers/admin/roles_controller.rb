module Admin
  class RolesController < BaseController
    before_action :set_user
    
    def create
      authorize current_user, :admin?

      @user.grant params[:id]
      redirect_to admin_users_path
    end

    def destroy
      authorize current_user, :admin?

      # TODO: Why is 'admin' getting removed
      @user.revoke params[:id]
      redirect_to admin_users_path
    end
  end
end
