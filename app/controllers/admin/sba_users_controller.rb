module Admin
  class SbaUsersController < BaseController
    def index
      @roles = Role.all
    end
  end
end
