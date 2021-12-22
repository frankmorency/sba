class AmIEligibleMailer < AsyncApplicationMailer
  layout 'email'

  def results_email(email_address, results)
    @results = results
    mail(to: email_address, subject: 'Am I Eligible email', template_path: 'custom/am_i_eligible/mailer', template_name: 'results_email')
  end
end
