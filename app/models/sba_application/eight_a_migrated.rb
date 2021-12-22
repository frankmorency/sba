require 'sba_application/master_application'

class SbaApplication::EightAMigrated < SbaApplication::EightAMaster
  class << self
    delegate  :log_success!, to: BdmisMigration
    delegate  :log_failure!, to: BdmisMigration
  end

  def self.update_approved!(org)
    cert = Certificate::EightA.find_by(organization: org)
    cert.update_attribute(:workflow_state, 'active')
    cert.sba_applications.initial.where.not(bdmis_case_number: nil).each do |app|
      app.update_attribute(:workflow_state, 'complete')
    end
  end

  def self.update!(org, status, csv)
    cert = Certificate::EightA.find_by(organization: org)
    app_id = nil
    
    if status ==  'suspended'
      cert.suspended = true
      cert.update_attribute(:workflow_state, 'active')
    else
      cert.update_attribute(:workflow_state, status)
      cert.sba_applications.initial.where.not(bdmis_case_number: nil).each do |app|
        app.update_attribute(:workflow_state, 'complete')
        app_id = app.id
      end
    end

    log_success! csv, app_id
  end

  def self.load!(org, csv, source_bucket, partial_prefix, creator = nil)
    s3 = S3Service.new
    transaction do
      previous_certificate = org.certificates.find_by(type: "Certificate::EightA")

      if previous_certificate
        if previous_certificate.current_application.try(:questionnaire).try(:name) == 'eight_a'
          previous_certificate.full_destroy ||
              log_failure!(csv, "Unable to destroy 8(a) document upload certificate") && return
        else
          return log_failure! csv, "Unexpected 8(a) Certificate ##{previous_certificate.id}"
        end
      end

      begin
        master_app = Questionnaire::EightAMigrated.find_by(name: 'eight_a_migrated').start_application(org)
        master_app.creator = creator if creator
        master_app.ignore_creator = true unless creator
        if (csv[:district_name])
          dt = DutyStation.find_by(name: csv[:district_name])
          master_app.duty_stations << dt
        end
        if csv[:case_number].blank? && csv[:last_recommendation] == 'reject'
          master_app.bdmis_case_number = 'MISSING INFO'
        else
          master_app.bdmis_case_number = csv[:case_number]
        end
        master_app.save!

      rescue Exception => e
        return log_failure! csv, "MASTER APP FAILED TO SAVE\nERRORS: #{master_app.errors.full_messages}\nEXCEPTION: #{e.message}\n#{e.backtrace.join('\n')}"
      end

      sub_app = master_app.sub_applications.first

      if sub_app.nil?
        return log_failure! csv, "NO SUB APP CREATED FOR MASTER APP\nID: #{master_app.try(:id)}"
      end

      begin
        answer = Answer.create!(sba_application: sub_app, question: Question.find_by(name: "bdmis_documents"))
      rescue Exception => e
        return log_failure! csv, "ANSWER FAILED TO SAVE\nID: #{master_app.try(:id)} -- #{sub_app.try(:id)}\nERRORS: #{answer.try(:errors).try(:full_messages)}\nEXCEPTION: #{e.message}\n#{e.backtrace.join('\n')}"
      end

      begin
        sub_app.ignore_creator = true
        sub_app.submit!
      rescue Exception => e
        return log_failure! csv, "SUB APP FAILED TO SUBMIT\nID: #{master_app.try(:id)}\nERRORS: #{sub_app.errors.full_messages}\nEXCEPTION: #{e.message}\n#{e.backtrace.join('\n')}"
      end

      if source_bucket && partial_prefix
        bucket = s3.get_bucket source_bucket
        documents = s3.get_resource.client.list_objects_v2({bucket: source_bucket, prefix: partial_prefix+csv[:hashed_duns]+'/'})
      end

      if documents && bucket
        Rails.logger.debug "Uploading from bucket: #{source_bucket} and key: #{partial_prefix+csv[:hashed_duns]}/"
        begin
          document_ids = []
          documents.contents.each do |s3_document|
            file_name = s3_document.key.split('/').last

            db_document = org.documents.new
            db_document.is_analyst = false
            db_document.stored_file_name = file_name # because the file name is already in S3. It is not generated from Rails app
            db_document.original_file_name = file_name
            db_document.is_active = true
            db_document.document_type_id = DocumentType.find_by(name: 'BDMIS Archive').id
            # Setting AV Status as "OK" to BDMIS Migrated docs. Plan is to do it offline and ahead of time of the import
            db_document.av_status = "OK"
            db_document.user = creator if creator
            db_document.save!
            document_ids << db_document.id

            object = bucket.object(s3_document.key)
            object.copy_to(bucket: ENV['AWS_S3_BUCKET_NAME'], key: org.folder_name+'/'+file_name)
          end

          Document.make_association(sub_app, document_ids)
          Document.make_association(answer, document_ids)
        rescue Exception => e
          return log_failure! csv, "DOCS FAILED\n#{e.message}\n#{e.backtrace.join('\n')}"
        end
      end

      unless previous_certificate
        begin
          master_app.submit!
          master_app.update_attribute :application_submitted_at, Chronic.parse(csv[:submitted_on_date]) || Time.now
        rescue Exception => e
          return log_failure! csv, "FAILED TO SUBMIT MASTER APP\nID: #{master_app.try(:id)}\nERRORS: #{master_app.errors.full_messages}\nEXCEPTION: #{e.message}\n#{e.backtrace.join('\n')}"
        end

        begin
          master_app.certificate.activate_for_bdmis!
          master_app.certificate.update_attributes(expiry_date: Chronic.parse(csv[:exit_date]), next_annual_report_date: Chronic.parse(csv[:next_review]), issue_date: Chronic.parse(csv[:approved_date]))
        rescue Exception => e
          return log_failure! csv, "FAILED TO ACTIVATE NEW CERT\nID: #{master_app.try(:id)}\nERRORS: #{master_app.try(:certificate_id)} #{master_app.errors.full_messages} -- #{master_app.certificate.try(:errors).try(:full_messages)}\nEXCEPTION: #{e.message}\n#{e.backtrace.join('\n')}"
        end


        if csv[:last_recommendation] == 'reject'
          master_app.certificate.update_attribute :rejected, true
          master_app.certificate.update_attribute :workflow_state, 'bdmis_rejected'
          master_app.update_attribute :workflow_state, 'complete'
        elsif csv[:last_recommendation] == 'suspend'
          master_app.certificate.update_attribute :suspended, true
        elsif Questionnaire::EightAMigrated::STATUS_MAP.keys.include? csv[:last_recommendation]
          master_app.certificate.update_attribute :workflow_state, Questionnaire::EightAMigrated::STATUS_MAP[csv[:last_recommendation]]
          master_app.update_attribute :workflow_state, 'complete'
        end
      end

      log_success! csv, master_app.try(:id)
    end
  end
end
