class DsbsReportMailer < ApplicationMailer
    # TODO: change to AsyncApplicationMailer above?
    layout 'layouts/email'
  
    def send_email(email_addresses, report_file)
      @human_date_time = DateTime.now.strftime("%m/%d/%Y  %H:%M %Z")
      @subject = "Dsbs Report as of #{@human_date_time} "
      @from_email = ENV["EMAIL_FROM_ADDRESS"] || 'from@mailinator.com'

      attachments['Dsbs_report.csv'] = File.read(Rails.root + report_file )
      mail(to: email_addresses,
           from: @from_email,
           subject: @subject,
           template_path: 'mail/reports',
           template_name: 'dsbs_report')
    end
  end
