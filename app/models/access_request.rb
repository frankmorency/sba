class AccessRequest < ActiveRecord::Base
  include Searchable

  acts_as_paranoid
  has_paper_trail

  belongs_to :user
  belongs_to :organization, { validate: false }

  # has_and_belongs_to_many :duty_stations
  has_many :office_requests
  has_many :duty_stations, through: :office_requests
  has_many :permission_requests

  alias_attribute :requestor, :user

  STATUSES = %w(requested accepted rejected revoked expired)

  before_validation :set_defaults, on: :create

  validates :user_id, presence: true

  validates :status, inclusion: { in: STATUSES }
  
  # Can't use after_save for now
  # because it create two records. 
  # Todo: Need to see where it do update after create. 
  after_create :permission_requests
  
  # Insert into permission_requests table 
  # to keep track of status change
  def permission_requests(current_user=nil)
    PermissionRequest.create(
        access_request_id: self.id,
        user_id: self.status == 'requested' ? self.user_id : current_user.id,
        action: self.status
      )
  end

  def self.expire_requests
    where(status: "requested").where("request_expires_on <= ?", Date.today).update_all status: "expired"
  end

  # Passing a parm that is un-used here but that is needed to pass the current user for testing for permissions on child classes
  def accept!(user, send_email = true)
    return false unless requested?
    # update_attributes(status: 'accepted', access_expires_on: expiry_for(:access_expires_on, 90))
    update_attributes!(status: "accepted", accepted_on: Time.now)
    permission_requests(user)
  end

  # Passing a parm that is un-used here but that is needed to pass the current user for testing for permissions on child classes
  def revoke!(current_user)
    return false unless accepted?
    update_attributes(status: "revoked")
    permission_requests(current_user)
  end

  # Passing a parm that is un-used here but that is needed to pass the current user for testing for permissions on child classes
  def reject!(current_user, send_email = true)
    return false unless requested?
    update_attributes(status: "rejected")
    permission_requests(current_user)
  end

  def request!(access_request_params)
    return false unless requested?
  end

  STATUSES.each do |stat|
    define_method(:"#{stat}?") do
      status == stat
    end
  end

  def expiry_for(field, default)
    (ExpirationDate.get(self, field) || default).days.from_now
  end

  def set_defaults
    self.status = "requested"
    self.request_expires_on = expiry_for(:request_expires_on, 7)
  end

  def role_name
    return SbaOrganizationMapping::humanize_roles_map(self.roles_map)
  end

  def assign_role(active_user)
    where(user_id: active_user.id)
  end

  def program
    if roles_map.to_s.include?("WOSB")
      return "WOSB, EDWOSB"
    elsif roles_map.to_s.include?("MPP")
      return "MPP"
    elsif roles_map.to_s.include?("8a")
      return "8(a)"
    end
  end

  def capasity
    if roles_map.to_s.include?("analyst")
      return "Analyst"
    elsif roles_map.to_s.include?("supervisor")
      return "Supervisor"
    end
  end

  def business_unit
    return SbaOrganizationMapping::BUSINESS_UNITS_CODE_TO_NAMES[roles_map.keys.first]
  end
  
  def self.to_csv
    attributes = [
        'Request Date', 'Role Type', 'Requestor', 'Requestor Email',
        'Reviewed Date', 'Reviewer', 'Reviewer Action', 'Reviewed Role', 'Reviewer Organization',
        'Revoked Date', 'Revoked By', 'Revoked By Role', 'Revoked By Organization'
      ]
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |req|
        data = [
            req.created_at.to_date.strftime('%Y-%m-%d'),
            req.type,
            req.user.first_name + ' ' + req.user.last_name,
            req.user.email,
          ]        
        approval = PermissionRequest.for_approval.find_by(access_request_id: req.id)
        if approval 
          approval = [
              approval.created_at.to_date.strftime('%Y-%m-%d'),
              approval.user.first_name + ' ' + approval.user.last_name,
              approval.action,
              approval.user.roles.map(&:name).join(','),
              approval.user.business_units.map(&:name).join(','),
            ]
          data.concat(approval)
        end
        revoked = PermissionRequest.revoked.find_by(access_request_id: req.id)
        if revoked
          revoked = [
              revoked.created_at.to_date.strftime('%Y-%m-%d'),
              revoked.user.first_name + ' ' + revoked.user.last_name,
              revoked.user.roles.map(&:name).join(','),
              revoked.user.business_units.map(&:name).join(','),
            ]
          data.concat(revoked)
        end
        
        csv << data
      end
    end
  end
end
