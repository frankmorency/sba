class ContributorMailer < AsyncApplicationMailer
  layout 'layouts/email'

  def invite(contributor_id, sender_id)
    @contributor = Contributor.find(contributor_id)
    @contributor_name = @contributor.full_name
    @vendor = User.find(sender_id)
    @vendor_name = @vendor.name
    @organization_name = @vendor.one_and_only_org.legal_business_name
    @program = "8(a)" # All these are 8(a) emails
    mail(to: @contributor.email, subject: "Please provide information for #{@organization_name} for the SBA #{@program} program", template_path: 'mail/contributors', template_name: 'invite')
  end  

  def reminder_to_complete_app(contributor_id, sender_id)
    @contributor = Contributor.find(contributor_id)
    @contributor_name = @contributor.full_name
    @vendor = User.find(sender_id)
    @vendor_name = @vendor.name
    @organization_name = @vendor.one_and_only_org.legal_business_name
    @program = "8(a)" # All these are 8(a) emails
    mail(to: @contributor.email, subject: "Reminder to provide information for #{@organization_name} for the SBA #{@program} program", template_path: 'mail/contributors', template_name: 'reminder_to_complete_app')
  end

  def revoked(email, name, sender_id, org_name)
    @contributor_name = name
    @vendor = User.find(sender_id)
    @vendor_name = @vendor.name
    @organization_name = org_name
    @program = "8(a)" # All these are 8(a) emails
    mail(to: email, subject: "#{@organization_name} removed you from its #{@program} application", template_path: 'mail/contributors', template_name: 'revoke')
  end

  def secondary_invite(contributor_id, sender_id)
    @contributor = Contributor.find(contributor_id)
    @contributor_name = @contributor.full_name
    @contributor_email = @contributor.email
    @vendor = User.find(sender_id)
    @vendor_name = @vendor.name
    @organization_name = @vendor.one_and_only_org.legal_business_name
    @program = "8(a)" # All these are 8(a) emails
    mail(to: @contributor_email, subject: "Please provide information for #{@organization_name} for the SBA #{@program} program", template_path: 'mail/contributors', template_name: 'invite')
  end
end
