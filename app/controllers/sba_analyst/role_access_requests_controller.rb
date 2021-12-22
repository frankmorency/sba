module SbaAnalyst
  class RoleAccessRequestsController < SbaAnalystController
    before_action :require_sba_analyst, except: [:create]
    before_action :ensure_max_or_sba_supervisor, except: [:new, :create]
    before_action :set_request, only: [:accept, :revoke, :reject]
    before_action :check_can_assign_role, except: [:create]

    include RequestAccessRequestsHelper
    include RespondAccessRequestsHelper
    include SupervisorAccessRequestsHelper

    def index
      super
    end

    # def new
    #   @role_list = params[:role_name]
    # end

    def create
      results_array = []
      faliures_array = []

      # Get an array of all the roles to add and all the IDs associated with it. 
      h = JSON.parse(params[:hash])
      @roles_list = h["role_name"].map{|h| h["role"]}

      params_options = {
       user_id: current_user.id
      }
      
      @roles_list.each do |role_name|
        role = Role.find_by(name: role_name)
        options = {user_id: params_options[:user_id], roles_map: SbaOrganizationMapping::create_roles_hash_from_roles_name_list({}, [role_name]), role_id: role.id}
        options[:duty_station_id] = h["duty_station_id"] if h["duty_station_id"] 

        access_request = SbaRoleAccessRequest.new(options)
        if access_request.request!(options)
          current_user.access_requests << access_request
          current_user.save!
          results_array << true
        else
          results_array << false
          faliures_array << "#{role_name}"
        end
      end
      @hash = Hash.new

      if results_array.all? {|values| values == true}
        @hash[:current_page] = "confirmation-sba-user"
      else
        @hash[:current_page] = "confirmation-sba-user-problem"
      end

      redirect_to request_role_path(hash: "#{@hash.to_json}")
    end

    def accept
      respond_to do |format|
        if @access_request.accept!(current_user)
          format.html { render nothing: true, status: :ok }
        else
          format.html { render nothing: true, status: :unprocessable_entity }
        end
      end
    end

    def revoke
      super
      redirect_to sba_analyst_role_access_requests_path
    end

    def reject
      respond_to do |format|
        if @access_request.reject!(current_user)
          format.html { render nothing: true, status: :ok }
        else
          format.html { render nothing: true, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_request
      @access_request = AccessRequest.where(id: params[:role_access_request_id]).first
    end

    def access_requests_params
      params.require(:access_request).permit(:user_id,
                                             :roles_map,
                                             :role_access_request_id,
                                             :id)
    end

    def check_can_assign_role
      list = %w(cods hq_program)
      roles = [:assign_wosb_role, :assign_mpp_role]
      list.each do |bu|
        roles << "assign_8a_role_#{bu}".to_sym
      end

      list = []
      roles.each do |role|
        list << current_user.can?(role, current_user)
      end

      if list.include?(true)
        return true
      else
        return false
      end
    end
  end
end
