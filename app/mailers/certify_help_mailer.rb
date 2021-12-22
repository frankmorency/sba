class CertifyHelpMailer < AsyncApplicationMailer
  layout 'layouts/email'
  
  def send_email(help_request)
        @help_request = help_request
        puts "--- Sending Email -----"
        mail(to: "help@certify.sba.gov", subject: @help_request['program'] + " - " + @help_request['issue'] + " - " + @help_request['duns'], template_path:'mail/certify_help', template_name:'request')
    end
    
end