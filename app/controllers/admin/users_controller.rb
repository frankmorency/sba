module Admin
  class UsersController < BaseController
    def index
      @users = User.all
      @roles = Role.all
    end
  end
end
