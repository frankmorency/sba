# This is for staff members requesting access roles to work on applications etc...
class VendorRoleAccessRequest < VendorAccessRequest
  FIELDS = {
    'Name' => 'users.last_name',
    'Solicitation #' => 'access_requests.solicitation_number',
    'Date' => 'access_requests.request_expires_on',
    'Access expires' => 'access_requests.access_expires_on',
    'Status' => 'access_requests.status',
    'DUNS #' => 'organizations.duns_number',
    'Role' => 'roles.name'
  }
  IGNORE = ['Request expires', 'Access expires']
  COUNTER = 10
  DEFAULT = 'Access expires'

  searchable fields: FIELDS, default: DEFAULT, ignore: IGNORE , per_page: COUNTER

  validates :roles_map, presence: true

  def self.add_first_user(user, org, role_name)
    roles_map = SbaOrganizationMapping::REVERSE_ROLES[role_name.to_s]
    transaction do
      access_request = create!(roles_map: roles_map, organization: org, user: user, role_id: Role.find_by(name:role_name).id)
      access_request.update_attributes!(status: 'accepted')
      user.organizations << org if org
      user.roles_map = roles_map
      user.save!
    end
  end

  def request!(access_request_params)
    super
    org = Organization.find(access_request_params["organization_id"])
    non_max_users = org.users
    users = users_with_permission(non_max_users, :assign_vendor_role)
    email_addresses =  users.map(&:email) unless users.blank?
    save!
    VendorRoleAccessRequestMailer.access_request_email(email_addresses, self).deliver
  end

  def accept!(current_user, send_email=true)
    if current_user.can? :assign_vendor_role
      # This will only assign the role if the user does not have a role, nor an organization.
      # This needs to be refactored with we will allow an user to have access to multiple organizations.
      user.add_role role.name if user.roles.blank?
      update_attribute!(role_id: role.id)
      user.organizations << organization if user.organizations.blank?
      user.save!
      super
      VendorRoleAccessRequestMailer.access_request_accepted_email(user.email, self).deliver if send_email
    end
  end

  def reject!(current_user)
    if current_user.can? :assign_vendor_role
      super
      VendorRoleAccessRequestMailer.access_request_rejected_email(user.email, self).deliver
    end
  end

  def revoke!(current_user)
    if current_user.can? :assign_vendor_role
      super
      user.roles_map = nil
      user.organizations.destroy(organization)
      user.save!
    end
  end

  def date
    result = nil
    if status == 'requested'
      result = request_expires_on
    elsif status == 'accepted'
      result = updated_at.to_date
    elsif status == 'rejected'
      result = updated_at.to_date
    elsif status == 'revoked'
      result = updated_at.to_date
    elsif status == 'expired'
      result = updated_at.to_date
    end
    result
  end

  private

  # This is only used by vendors right now.
  def users_with_permission(users, permission)
    list = []
    users.each do |u|
      list << u if u.can?(permission, u) && u.id != user.id # Don't include user if it's the same as the requestor
    end    
    return list
  end

end
