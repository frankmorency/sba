class ContractOfficerAccessRequestMailer < AsyncApplicationMailer
  layout 'layouts/email'

  def access_request_email(email_addresses, solicitation_number, user)
    @solicitation_number = solicitation_number
    @user = user
    mail(to: email_addresses, subject: 'certify.SBA.gov Contracting Officer Access Request Received', template_path: 'mail/access_requests/contract_officer_access_requests', template_name: 'access_request')
  end                                  

  def access_request_accepted_email(email, request)
    @access_request = request
    @organization = Organization.find(request["organization_id"])
    mail(to: email, subject: "certify.SBA.gov - Request to review #{@organization.name}’s WOSB records has been granted", template_path: 'mail/access_requests/contract_officer_access_requests', template_name: 'accepted')
  end

  def access_request_rejected_email(email, request)
    @access_request = request
    @organization = Organization.find(request["organization_id"])
    mail(to: email, subject: "certify.SBA.gov - Request to review #{@organization.name}’s WOSB records has been denied", template_path: 'mail/access_requests/contract_officer_access_requests', template_name: 'rejected')
  end
end