module Admin
 # The controller for resetting the Test Data, used by the Behavior Tests to cleanup after tests are complete
  class ResetController < BaseController

    respond_to :json

    def contributor
      begin
        email = params[:email]
        c = Contributor.find_by_email(email)
        c.destroy! if c

        u = User.find_by_email(email)
        if u
          u.roles_map = nil
          u.save!
          u.destroy!
        end
      rescue => e
        render json: e.Message, :status => 500
      end

      render json: "Success", :status => 200
    end
  end
end
