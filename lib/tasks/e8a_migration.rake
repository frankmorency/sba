require Rails.root.join("lib/e8a/importer.rb")

namespace :data_migration do
  # USAGE: rake data_migration:import_e8a[test-requirement-documents,180913_requirements_last_10_years_master.csv]
  desc "Loads data from e8a system (csv file) into Certify DB. AgencyRequirements and associated objects. " +
    "USAGE: rake data_migration:import_e8a[s3-bucket-name,s3-file-key]"
  task :import_e8a, [:s3_bucket, :s3_file_key] => [:environment] do |task, args|
    Rails.logger = Logger.new(STDOUT)
    Rails.logger.info "Starting rake data_migration:import_e8a[#{args[:s3_bucket]}, #{args[:s3_file_key]}]"

    if args[:s3_bucket].blank?
      Rails.logger.error "data_migration:import_e8a s3_bucket not supplied. Exiting"
    elsif args[:s3_file_key].blank?
      Rails.logger.error "data_migration:import_e8a s3_file_key not supplied. Exiting"
    end

    importer = E8A::Importer.new(args[:s3_bucket], args[:s3_file_key])
    importer.load_from_csv!
    Rails.logger.info "Finished rake data_migration:import_e8a[#{args[:s3_bucket]}, #{args[:s3_file_key]}]"
  end
end
