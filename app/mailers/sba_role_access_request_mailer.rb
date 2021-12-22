class SbaRoleAccessRequestMailer < AsyncApplicationMailer
  layout 'layouts/email'
  
  def access_request_email(email, access_request)
    @email = email
    check_email_list_size
    @access_request = SbaRoleAccessRequest.find(access_request["id"])
    @user = @access_request.user
    @role = SbaOrganizationMapping::humanize_roles_map(@access_request.roles_map)
    mail(to: @email,
         subject: 'certify.SBA.gov - Responsibility Access Request Received',
         template_path: 'mail/access_requests/sba_role_access_requests',
         template_name: 'access_request')
  end

  def access_request_accepted_email(email, access_request)
    @email = email
    check_email_list_size
    @access_request = SbaRoleAccessRequest.find(access_request["id"])
    @role = SbaOrganizationMapping::humanize_roles_map(@access_request.roles_map)
    mail(to: @email, subject: "certify.SBA.gov - Responsibility has been granted",
         template_path: 'mail/access_requests/sba_role_access_requests',
         template_name: 'accepted')
  end

  def access_request_rejected_email(email, access_request)
    @email = email
    check_email_list_size
    @access_request = SbaRoleAccessRequest.find(access_request["id"])
    @role = SbaOrganizationMapping::humanize_roles_map(@access_request.roles_map)
    mail(to: @email,
         subject: "certify.SBA.gov - Responsibility has been rejected",
         template_path: 'mail/access_requests/sba_role_access_requests',
         template_name: 'rejected')
  end


  private

  def check_email_list_size
    if @email.size > 50 
      @email = @email[0..49]
    end
  end

end
