require_relative '../../app/mailers/application_mailer'
require_relative '../../app/mailers/async_application_mailer'
require_relative '../../lib/idp/import_status'

namespace :idp do
  desc "Generated and emails a report of IdP migration status."
  task :import_status => :environment do
    Rails.logger.info "Started rake idp:import_status #{Time.now}"
    puts "Started rake idp:import_status #{Time.now}"

    import_status = Idp::ImportStatus.new
    import_status.run

    Rails.logger.info "Finished rake idp:import_status #{Time.now}"
    puts "Finished rake idp:import_status #{Time.now}"
  end
end
