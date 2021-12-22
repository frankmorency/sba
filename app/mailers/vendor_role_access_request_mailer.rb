class VendorRoleAccessRequestMailer < AsyncApplicationMailer
  layout 'layouts/email'

  def access_request_email(email_addresses, access_request)
    @access_request = VendorRoleAccessRequest.find(access_request["id"])
    @user = @access_request.user
    @org = @access_request.organization
    @role = SbaOrganizationMapping::humanize_roles_map(@access_request.roles_map)
    mail(to: email_addresses, subject: 'certify.SBA.gov - Access Request', template_path: 'mail/access_requests/vendor_role_access_requests', template_name: 'access_request')
  end
  
  def access_request_accepted_email(email, access_request)
    @access_request = VendorRoleAccessRequest.find(access_request["id"])
    @role = SbaOrganizationMapping::humanize_roles_map(@access_request.roles_map)
    mail(to: email, subject: "certify.SBA.gov - Access Request approved", template_path: 'mail/access_requests/vendor_role_access_requests', template_name: 'accepted')
  end
  
  def access_request_rejected_email(email, access_request)
    @access_request = VendorRoleAccessRequest.find(access_request["id"])
    @role = SbaOrganizationMapping::humanize_roles_map(@access_request.roles_map)
    mail(to: email, subject: "certify.SBA.gov - Access Request Denied", template_path: 'mail/access_requests/vendor_role_access_requests', template_name: 'rejected')
  end
  
end