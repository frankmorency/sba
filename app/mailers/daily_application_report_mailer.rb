class DailyApplicationReportMailer < AsyncApplicationMailer
  layout 'layouts/email'
  def send_email(email_addresses, report_file = "/tmp/daily_application_report.txt")
    @subject = "Daily Application Report as of #{DateTime.now}"
    attachments['daily_application_report.txt'] = File.read(report_file)
    mail(to: email_addresses,
         subject: @subject,
         template_path: 'mail/reports',
         template_name: 'daily_application_report')
  end
end
