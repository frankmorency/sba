class MaxUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_max_user
  before_action :process_params, only: :assign_role

  def request_role

    @hash = JSON.parse(params[:hash]) if params[:hash]

    if @hash.nil?
      @hash = Hash.new
    end

    if @hash["current_page"]
      @hash[:current_page] = @hash["current_page"]
    elsif current_user.access_requests && current_user.access_requests.map{|ar| ar.status == "requested"}.include?(true)
      @hash[:current_page] = "already-requested-roles"
    elsif current_user.access_requests && current_user.access_requests.map{|ar| ar.status == "rejected"}.include?(true)
      @hash[:current_page] = "role-rejected"
    else
      @hash[:current_page] = "landing"
    end
  end

  def next_page

    @hash = JSON.parse(params[:hash])

    # We request the capasity (Supervisor / Analyst / Contracting Officer )
    if params[:capasity]
      @hash[:capasity] = params[:capasity]
      if @hash[:capasity] == "co"
        @hash[:current_page] = "review-request-access"
        @hash[:role_name] = determine_roles_list(@hash)
      else
        @hash[:current_page] = "request-sba-access"
      end
    # We request the Program (8a / WOSB / MPP )
    elsif params[:program]
      @hash[:program] = params[:program]
      if @hash[:program] == "8a"
        @hash[:current_page] = "request-8a-business-unit"
      else
        @hash[:current_page] = "review-request-access"
        @hash[:role_name] = determine_roles_list(@hash)
        @hash[:destination] = sba_analyst_role_access_requests_url
      end
    # If we are 8a We request the Business Unit
    elsif params[:business_unit]
      # handle multiple business units.
      # Keeping this code because this is for multiple roles and bu
      # @hash[:business_unit] = params[:business_unit].keys
      @hash[:business_unit] = params[:business_unit]

      @hash[:current_page] = "request-8a-duty-station"
    # If we are 8a We request the Duty Station
    elsif params[:duty_station]
      @hash[:duty_station_id] = params[:duty_station][:duty_station].to_i
      @hash[:current_page] = "review-request-access"
      @hash[:role_name] = determine_roles_list(@hash)
      @hash[:destination] = sba_analyst_role_access_requests_url
    else
      @hash[:current_page] = "landing"
    end
    render :request_role
  end

  def assign_role

    @hash = JSON.parse(params[:hash]) if params[:hash]

    if @hash.nil? || @hash["role_name"].nil? ||  @hash["role_name"].empty?
      redirect_to request_role_url
    elsif @hash && @hash["role_name"] && @hash["role_name"][0]["role"] == "federal_contracting_officer"
      # Assign co roles immedialty
      VendorRoleAccessRequest.add_first_user(current_user, nil, "federal_contracting_officer")
      @hash[:current_page] = "confirmation-co"
      render :request_role
    else
      redirect_to sba_analyst_role_access_requests_path( hash: @hash ), method: 'post'
    end
  end

  def process_params
    @roles_map = SbaOrganizationMapping::process_checkboxes(params)
  end

  private

  def determine_roles_list(hash)
    role_list = []
    if hash[:capasity] == "co"
      role_list << { name: SbaOrganizationMapping::ROLES_SYSTEM_ROLES_HUMANIZED["federal_contracting_officer"], role: "federal_contracting_officer" }
    elsif hash["capasity"] == "analyst" || hash["capasity"] == "supervisor"
      if hash[:program] == "wosb" ||  hash[:program] == "mpp"
        role_list << { name: SbaOrganizationMapping::ROLES_SYSTEM_ROLES_HUMANIZED["sba_#{hash["capasity"]}_#{hash[:program]}"], role: "sba_#{hash["capasity"]}_#{hash[:program]}" }
      elsif hash["program"] == "8a"
        # Keeping this code because this is for multiple roles and bu
        # hash["business_unit"].each do |bu|
        #   role_list << { name: SbaOrganizationMapping::ROLES_SYSTEM_ROLES_HUMANIZED["sba_#{hash["capasity"]}_#{hash["program"]}_#{bu}"], role: "sba_#{hash["capasity"]}_#{hash["program"]}_#{bu}" }
        # end
        bu = hash["business_unit"]
        role_list << { name: SbaOrganizationMapping::ROLES_SYSTEM_ROLES_HUMANIZED["sba_#{hash["capasity"]}_#{hash["program"]}_#{bu}"], role: "sba_#{hash["capasity"]}_#{hash["program"]}_#{bu}" }
      end
    else
      raise "Invalid Permission Request"
    end
    role_list
  end
end
