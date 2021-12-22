module SbaAnalyst
  class ProfileController < SbaAnalystController

    def index
      @role_list = current_user.roles.map{ |r| r.name }
    end
  end
end