class SbaRoleAccessRequest < AccessRequest

  FIELDS = {
    'Name' => 'users.last_name',
    'Date' => 'access_requests.request_expires_on',
    'Access expires' => 'access_requests.access_expires_on',
    'Status' => 'access_requests.status'
  }
  IGNORE = ['Request expires', 'Access expires', 'Role']
  COUNTER = 10
  DEFAULT = 'Access expires'

  searchable fields: FIELDS, default: DEFAULT, ignore: IGNORE , per_page: COUNTER

  validates :roles_map, presence: true

  attr_accessor :duty_station_id

  def request!(request_access_params)
    super

    # associate the duty_station if there is one to the access request
    dt = nil
    if request_access_params[:duty_station_id]
      dt = DutyStation.find(request_access_params[:duty_station_id])
      self.duty_stations << dt
      request_access_params.delete("duty_station_id")
      dt = dt.id
    end

    save!

    emails_list = approver_emails_list(roles_map, dt)
    emails_list.uniq! unless emails_list.empty?

    # The we need to figure out who will send the email
    SbaRoleAccessRequestMailer.access_request_email(emails_list, self).deliver
  end

  def accept!(current_user, send_email=true)
    if current_user.can_any? :assign_analyst_role, :assign_mpp_role, :assign_8a_role
      super
      SbaOrganizationMapping::add_hash_role(user, self.roles_map)
      SbaRoleAccessRequestMailer.access_request_accepted_email(user.email, self).deliver if send_email
    else
      bu = roles_map.keys.first.downcase
      role = "assign_8a_role_#{bu}".to_sym
      if current_user.can? role
        super
        SbaOrganizationMapping::add_hash_role(user, self.roles_map)
        duty_stations.each do |dt|
          user.duty_stations << dt
        end
        SbaRoleAccessRequestMailer.access_request_accepted_email(user.email, self).deliver if send_email
      end
    end    
    save
  end

  def reject!(current_user, send_email=true)
    if current_user.can_any? :assign_analyst_role, :assign_mpp_role, :assign_8a_role
      super
      SbaRoleAccessRequestMailer.access_request_rejected_email(user.email, self).deliver
    else
      bu = roles_map.keys.first.downcase
      role = "assign_8a_role_#{bu}".to_sym
      if current_user.can? role
        super
        SbaRoleAccessRequestMailer.access_request_rejected_email(user.email, self).deliver if send_email
      end
    end
    save
  end

  def revoke!(current_user)
    if current_user.can_any? :assign_analyst_role, :assign_mpp_role, :assign_8a_role
      user.roles_map = nil
      user.save!
      super
    else
      bu = roles_map.keys.first.downcase
      role = "assign_8a_role_#{bu}".to_sym
      if current_user.can? role
        super
        SbaOrganizationMapping::remove_hash_role(user, self.roles_map)        
        user.duty_stations.destroy_all
      end
    end
    save
  end

  def approver_emails_list(permission)
    max_users = nil

    if permission.to_s.include?("8a")
      max_users = User.joins(:duty_stations).where('max_id IS NOT NULL')
    else
      max_users = User.where('max_id IS NOT NULL')
    end

    users = users_with_permission(max_users, permission) 
    email_addresses =  users.map(&:email) unless users.blank?
  end

  private

  def approver_emails_list(roles_map, dt_id=nil)
    # This is code to figure out what role the supervisor needs to have before getting an array of emails.
    role = nil
    if roles_map && roles_map["Legacy"] && roles_map["Legacy"]["WOSB"]
      role = 'sba_supervisor_wosb'
    elsif roles_map && roles_map["Legacy"] && roles_map["Legacy"]["MPP"]
      role = 'sba_supervisor_mpp'
    elsif roles_map && roles_map["Legacy"] && roles_map["Legacy"]["VENDOR"]
      raise "This option is invalid something is wrong."
    else
      role = SbaOrganizationMapping::ROLES[roles_map.keys.first]["8a"]["supervisor"].first
    end

    list = []
    list = User.with_role role

    list = list.joins(:duty_stations).where(duty_stations: {id: dt_id}) unless dt_id.nil?
    return list.map(&:email) unless list.blank?
    return list
  end

end
