namespace :utils do
  desc "Send out email from rails"
  task :send_email, [:email] =>[:environment, :log_to_stdout] do |t, args|
    param = args[:email]
    Rails.logger.info "Sending test to email #{param} from #{Rails.env} on #{Time.now.getutc}"
    ActionMailer::Base.mail(from: "SBACertify@certify.sba.gov",
                            to: param, 
                            subject: "Test email from #{Rails.env} on #{Time.now.getutc}", 
                            body: "This is a test from #{Rails.env} on #{Time.now.getutc}",
                            content_type: "text/html").deliver
    Rails.logger.info "Test email sent to #{param} from #{Rails.env} on #{Time.now.getutc}"
  end
end