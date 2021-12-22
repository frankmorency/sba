require 'csv'
namespace :data_migration do
  desc "Loads extracted data from BDMIS system (csv files) into Certify DB. Organization and Documents in this round."
  task :load_bdmis_initial_archive, [:source_bucket, :partial_prefix] => [:environment] do |task, args|
    # ****************************************************
    # Sample csv files with various BDMIS data
    # business.csv with all the Business Information that needs to be migrated. Columns - duns, tax_identifier_number
    # documents.csv with all the PDF documents to be migrated. Columns - duns, file_name
    # Check lib/tasks/bdmis_sample for sample CSV's and sample files used
    # ****************************************************
    Rails.logger = Logger.new(STDOUT)

    directory = 'db/fixtures/bdmis/initial_import' unless args[:directory]

    Questionnaire::EightAMigrated.load_from_csv!('db/fixtures/bdmis/initial_import', args[:source_bucket], args[:partial_prefix])
  end

  desc "Loads extracted data from BDMIS system (csv files) into Certify DB. Organization and Documents in this round."
  task :load_bdmis_second_import, [:source_bucket, :partial_prefix] => [:environment] do |task, args|
    # ****************************************************
    # Sample csv files with various BDMIS data
    # business.csv with all the Business Information that needs to be migrated. Columns - duns, tax_identifier_number
    # documents.csv with all the PDF documents to be migrated. Columns - duns, file_name
    # Check lib/tasks/bdmis_sample for sample CSV's and sample files used
    # ****************************************************
    Rails.logger = Logger.new(STDOUT)

    Questionnaire::EightAMigrated.load_from_csv!('db/fixtures/bdmis/sprint_2_import', args[:source_bucket], args[:partial_prefix])
  end

  desc "Loads extracted data from BDMIS system (csv files) into Certify DB. Organization and Documents in this round."
  task :load_bdmis_third_import, [:source_bucket, :partial_prefix] => [:environment] do |task, args|
    # ****************************************************
    # Sample csv files with various BDMIS data
    # business.csv with all the Business Information that needs to be migrated. Columns - duns, tax_identifier_number
    # documents.csv with all the PDF documents to be migrated. Columns - duns, file_name
    # Check lib/tasks/bdmis_sample for sample CSV's and sample files used
    # rake data_migration:load_bdmis_third_import
    # ****************************************************
    Rails.logger = Logger.new(STDOUT)

    Questionnaire::EightAMigrated.load_from_csv!('db/fixtures/bdmis/sprint_10_import', args[:source_bucket], args[:partial_prefix])
  end

  desc "Load BDMIS Documents from CSV file"
  task :load_bdmis_documents, [:csv_file_path] => [:environment] do |t, args|
    Rails.logger = Logger.new("/var/log/rails/bdmis_docs_cron_out_#{Time.now.to_i}.log")
    csv_file = args[:csv_file_path]
    source_bucket = "sba-prod-external-data"
    doc_type = DocumentType.find_by(name: 'BDMIS Archive').id
    s3 = S3Service.new
    if csv_file.present?
      CSV.foreach(csv_file, headers: true, header_converters: :symbol) do |line|
        file_name = line[:new_filename]
        original_name = line[:old_filename]
        duns = line[:duns]
        file_key = line[:file_s3_location]
        bucket = s3.get_bucket source_bucket
        begin
          org = Organization.find_by_duns_number duns
          bdmis_application = org.sba_applications.where("bdmis_case_number IS NOT NULL").first

          if bdmis_application.nil?
            Rails.logger.info("#{duns}, #{file_name}, BDMIS Application does not exist")
          end

          sub_application = bdmis_application.sub_applications.first
          if sub_application.nil?
            Rails.logger.info("#{duns}, #{file_name}, BDMIS Sub Application does not exist")
          end

          count = sub_application.documents.where(original_file_name: file_name).count

          bdmis_key = "bdmis_final/files/#{file_key}"
          object = bucket.object(bdmis_key)
          certify_key = org.folder_name+'/'+original_name
          creator = bdmis_application.creator

          if count > 0
            object.copy_to(bucket: ENV['AWS_S3_BUCKET_NAME'], key: certify_key)
            Rails.logger.info("#{duns}, #{file_name}, Updated")
            # Copy just the file
          else
            # Create the record and copy file
            answer = sub_application.answers.first
            db_document = org.documents.new
            db_document.is_analyst = false
            db_document.stored_file_name = original_name # because the file name is already in S3. It is not generated from Rails app
            db_document.original_file_name = file_name
            db_document.is_active = true
            db_document.document_type_id = doc_type
            # Setting AV Status as "OK" to BDMIS Migrated docs. Plan is to do it offline and ahead of time of the import
            db_document.user = creator if creator
            db_document.save!
            db_document.av_status = "OK"
            db_document.save!
            document_ids = []
            document_ids << db_document.id
            object.copy_to(bucket: ENV['AWS_S3_BUCKET_NAME'], key: certify_key)
            Document.make_association(sub_application, document_ids)
            Document.make_association(answer, document_ids)
            Rails.logger.info("#{duns}, #{file_name}, Created")
          end
        rescue Exception => e
          Rails.logger.info("#{duns}, #{file_name}, #{e.message}")
        end
      end
    end
  end
end
