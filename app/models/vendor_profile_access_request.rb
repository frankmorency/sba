# This of for the CO's Request accesses to the Vendor's profile
#  Co is a little bit diffrent than the other AC they are granted the permission immediately
class VendorProfileAccessRequest < VendorAccessRequest

  FIELDS = {
    'Name' => 'users.last_name',
    'Solicitation #' => 'access_requests.solicitation_number',
    'Request expires' => 'access_requests.request_expires_on',
    'Access expires' => 'access_requests.access_expires_on',
    'Status' => 'access_requests.status',
    'DUNS #' => 'organizations.duns_number'
  }

  IGNORE = ['Request expires', 'Access expires']
  COUNTER = 10
  DEFAULT = 'Access expires'

  searchable fields: FIELDS, default: DEFAULT, ignore: IGNORE , per_page: COUNTER

  validates :solicitation_naics, length: {maximum: 6, minimum: 6}

  def accept!(current_user, send_email=true)
    if current_user.can? :grant_access_to_vendor_profile
      update_attributes(access_expires_on: expiry_for(:access_expires_on, 90), status: 'accepted', accepted_on: Time.now)
      ContractOfficerAccessRequestMailer.access_request_accepted_email(user.email, self).deliver if send_email
    end
  end

  def reject!(current_user)
    if current_user.can? :grant_access_to_vendor_profile
      super
      ContractOfficerAccessRequestMailer.access_request_rejected_email(user.email, self).deliver
    end
  end

  def revoke!(current_user)
    if current_user.can? :grant_access_to_vendor_profile
      super
    end
  end

end
