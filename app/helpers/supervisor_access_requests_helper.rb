module SupervisorAccessRequestsHelper

  def index
    AccessRequest.expire_requests

    access_list = []
    list = nil
    if can?(:assign_wosb_role, current_user)
      access_list = SbaRoleAccessRequest.where("access_requests.roles_map#>>'{Legacy}' LIKE '%WOSB%' ")
    elsif can?(:assign_mpp_role, current_user)
      access_list = SbaRoleAccessRequest.where("access_requests.roles_map#>>'{Legacy}' LIKE '%MPP%' ")
    elsif can?(:assign_8a_role, current_user)
      access_list = SbaRoleAccessRequest.where("access_requests.roles_map#>>'{Legacy}' LIKE '%8a%' ")
    # RELATES TO THE APPROVAL OF 8A roles
    elsif current_user.can? :assign_8a_role_cods
      list = SbaRoleAccessRequest.where("access_requests.roles_map::jsonb ? 'CODS' ")
    elsif current_user.can? :assign_8a_role_hq_program
      list = SbaRoleAccessRequest.where("access_requests.roles_map::jsonb ? 'HQ_PROGRAM' ")
    elsif current_user.can? :assign_8a_role_hq_aa
      list = SbaRoleAccessRequest.where("access_requests.roles_map::jsonb ? 'HQ_AA' ")
    elsif current_user.can? :assign_8a_role_district_office
      list = SbaRoleAccessRequest.where("access_requests.roles_map::jsonb ? 'DISTRICT_OFFICE' ")
    elsif current_user.can? :assign_8a_role_hq_ce
      list = SbaRoleAccessRequest.where("access_requests.roles_map::jsonb ? 'HQ_CE' ")
    elsif current_user.can? :assign_8a_role_ops
      list = SbaRoleAccessRequest.where("access_requests.roles_map::jsonb ? 'OPS' ")
    elsif current_user.can? :assign_8a_role_size
      list = SbaRoleAccessRequest.where("access_requests.roles_map::jsonb ? 'SIZE' ")
    elsif current_user.can? :assign_8a_role_hq_legal
      list = SbaRoleAccessRequest.where("access_requests.roles_map::jsonb ? 'HQ_LEGAL' ")
    elsif current_user.can? :assign_8a_role_oig
      list = SbaRoleAccessRequest.where("access_requests.roles_map::jsonb ? 'OIG' ")
    else
      list = SbaRoleAccessRequest.where(id: 0)
    end

    unless current_user.can_any?(:assign_wosb_role, :assign_mpp_role, :assign_8a_role)
      # Do not filter access requests by Duty Station for HQ_Legal users. They are very distributed and need the ability for HQ_LEGAL Supervisors to approve
      unless current_user.can? :assign_8a_role_hq_legal
        list = list.select{|ar| ar if current_user.duty_stations.include?(ar.duty_stations.first) }
      end
      access_list = SbaRoleAccessRequest.where(id: list.map(&:id)) unless list.empty?
    end

    if access_list.empty?
      # This returns an active relation rather than an array! So that we can do a .where clause somewhere else
      # Without having an exception. This is used on access_request_static_popup
      @access_requests = SbaRoleAccessRequest.where(id: 0)
    else
      @access_requests = access_list.joins(:user).sba_search(
                       params[:search_input],
                       page: params[:page],
                       sort: {
                         column: params[:sort],
                         direction: sort_direction
                       })
    end

    @access_requests
  end

end
