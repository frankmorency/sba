class WosbExpiryReminderMailer < AsyncApplicationMailer
  layout 'layouts/email'

  def send_email(email_addresses, num_of_days, expiration_date, business_name, program)
    @business_name = business_name
    @program = program
    @num_of_days = num_of_days
    @expiration_date = expiration_date
    @subject = "Reminder: SBA Certificate expires in #{@num_of_days} day(s)"
    mail(to: email_addresses, subject: @subject, template_path: 'mail/wosb_expiry_reminder', template_name: 'mail')
  end

end
