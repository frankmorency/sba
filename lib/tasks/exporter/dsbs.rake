require_relative '../../../app/mailers/application_mailer'
require_relative '../../../app/mailers/async_application_mailer'

namespace :exporter do
  desc "Executes an 8a certificates query for DSBS and uploads results to Minerva"
  task :dsbs, [:csv] => :environment do |t, args|
    cron = CronJobHistory.new
    cron.type = "exporter:dsbs"
    cron.start!

    if args[:csv].nil?
      csv = Rails.env.production? ? "certify_certificates.csv" : "certify_certificates_test.csv"
    else
      csv = args[:csv]
    end

    host = ENV["MINERVA_SERVER"]
    name = ENV["MINERVA_EXPORTER_DSBS_USER"]
    pwd = ENV["MINERVA_EXPORTER_DSBS_PW"]

    # for local dev/testing, be sure to "export RAILS_LOG_TO_STDOUT='yes'" to redirect the rake_logger
    if (ENV["RAILS_LOG_TO_STDOUT"].present? || Rails.env.test?)

      rake_logger = ActiveSupport::Logger.new(STDOUT)
    else
      rake_logger = ActiveSupport::Logger.new("/var/log/rails/export_agent.log")
    end
    rake_logger.info("#{Time.now} Executing rake task exporter:dsbs.")

    begin
      exporter = Exporter::Dsbs.new

      email_addresses = if Rails.env.production? then
        ["hilary.cronin@sba.gov", "Terrance.Lewis@sba.gov", "William.LukeJR@sba.gov", "Nidhi.Dharithreesan@sba.gov",
          "bassettconsulting@gmail.com", "Rahul.Gundala@sba.gov", "sam.harris@sba.gov"]
      else
        ["William.LukeJR@sba.gov"]
      end

      # Comment the line below when testing in a local environment
      exporter.run(host: host, name: name, pw: pwd, filename: csv, emails: email_addresses)

      # Uncomment the line below when testing in a local env with emails. 
      # exporter.run(host: 'localhost', name: 'name', pw: 'pwd', filename: '/tmp/' + csv, emails: email_addresses)
      
      # exporter.run(path: "/tmp/", filename: csv)
      
    ensure
      rake_logger.info("#{Time.now} Completed rake task exporter:dsbs.\n")
    end

    cron.stop!
  end
end
