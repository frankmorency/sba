class IdpMailer < AsyncApplicationMailer
  layout 'layouts/email'

  def migration_report(email_addresses, report)
    @report = JSON.parse(report)
    mail(to: email_addresses, subject: 'IdP Migration Report', template_path: 'mail/idp_mailer')
  end
end
