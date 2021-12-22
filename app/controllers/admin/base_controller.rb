module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_application_admin
    before_action :not_in_production

    protected

    def set_user
      @user = User.find(params[:user_id])
    end
  end
end
