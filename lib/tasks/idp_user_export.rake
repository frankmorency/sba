require_relative '../../lib/idp/user_exporter'
require_relative '../../lib/idp/role_exporter'

namespace :idp do
  desc "Export user data into a CSV, for import into IdP, and uploads it to S3"
  task :user_export, [:filename]  => :environment do |task, args|
    Rails.logger.info "Started rake idp:user_export #{Time.now}"
    puts "Started rake idp:user_export #{Time.now}"
    filename = args[:filename]
    ue = Idp::UserExporter.new(filename)
    ue.run
    Rails.logger.info "Finished rake idp:user_export #{Time.now}"
    puts "Finished rake idp:user_export #{Time.now}"
  end

  desc "Exports user role data into a CSV, and uploads it to S3"
  task :role_export, [:filename]  => :environment do |task, args|
    Rails.logger.info "Started rake idp:role_export #{Time.now}"
    puts "Started rake idp:role_export #{Time.now}"
    filename = args[:filename]
    ue = Idp::RoleExporter.new(filename)
    ue.run
    Rails.logger.info "Finished rake idp:role_export #{Time.now}"
    puts "Finished rake idp:role_export #{Time.now}"
  end
end
