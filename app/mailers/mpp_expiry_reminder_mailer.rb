class MppExpiryReminderMailer < ApplicationMailer
  layout 'layouts/email'
  # Setup MPP Emails to have a cc. In Production use MPP supplied address
  default cc: Rails.env.production? ? "asmppannualreporting@sba.gov" : "mppcctest@mailinator.com"

  def send_60_day_reminder(cert, email)
    org = Organization.find(cert.organization_id)
    @business_name = org.name
    @email_addresses = email
    date_on_email = cert.next_annual_report_date - 30.days
    @expiration_date = date_on_email.strftime("%m/%d/%Y")
    @subject = "Notification of annual reporting requirement due"
    #mail(to: @email_addresses, subject: @subject, template_path: 'mail/mpp_expiry_reminder')
  end

  def send_45_day_reminder(cert, email)
    org = Organization.find(cert.organization_id)
    @business_name = org.name
    @email_addresses = email
    date_on_email = cert.next_annual_report_date - 30.days
    @expiration_date = date_on_email.strftime("%m/%d/%Y")
    @subject = "Repeat notification and reminder of due date"
    #mail(to: @email_addresses, subject: @subject, template_path: 'mail/mpp_expiry_reminder')
  end

  def send_30_day_reminder(cert, email)
    org = Organization.find(cert.organization_id)
    @business_name = org.name
    @email_addresses = email
    date_on_email = cert.next_annual_report_date - 20.days
    @expiration_date = date_on_email.strftime("%m/%d/%Y")
    @subject = "Notification that you have missed the deadline for submittal"
    #mail(to: @email_addresses, subject: @subject, template_path: 'mail/mpp_expiry_reminder')
  end

  def send_past_1_day_reminder(cert, email)
    org = Organization.find(cert.organization_id)
    @business_name = org.name
    @email_addresses = email
    date_on_email = cert.next_annual_report_date + 31.days
    @expiration_date = date_on_email.strftime("%m/%d/%Y")
    @subject = "You have missed the final deadline and consequences"
    #mail(to: @email_addresses, subject: @subject, template_path: 'mail/mpp_expiry_reminder')
  end
end
