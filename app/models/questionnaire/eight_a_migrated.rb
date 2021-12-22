require 'questionnaire/master_questionnaire'
require 'csv'

class Questionnaire::EightAMigrated < Questionnaire::MasterQuestionnaire
  REQUIRED_FIELDS = [:approval_date, :company_name, :decline_date, :ein, :next_review, :office, :submitted_on_date, :exit_date, :approved_date, :office_code, :district_code, :duns, :status]

  STATUS_MAP = {
    'withdraw' => 'withdrawn',
    'earlygrad' => 'early_graduated',
    'graduate' => 'graduated',
    'terminate' => 'terminated',
    'suspend' => 'suspended',
    'reject' => 'bdmis_rejected'
  }

  def self.load_from_csv!(directory, source_bucket = nil, partial_prefix = nil)
    CSV.foreach("#{directory}/business.csv", headers: true, header_converters: :symbol) do |line|
      missing_headers = REQUIRED_FIELDS - line.headers

      unless missing_headers.blank?
        raise "Invalid business.csv format.  Missing headers: #{missing_headers}"
      end

      sam_org = MvwSamOrganization.get(line[:duns])

      if sam_org.nil?
        BdmisMigration.log_failure! line, "No record found in SAM database for DUNS: #{line[:duns]}"
        next
      end

      begin
        org = Organization.find_by(duns_number: line[:duns])
        if org.nil?
          Rails.logger.info "No record found for DUNS - #{line[:duns]} in Certify DB. Proceeding to create record."
          # Prompt if SAM Tax Identifier is different from what's in BDMIS
          if sam_org.tax_identifier_number && sam_org.tax_identifier_type
            org = Organization.create(duns_number: line[:duns], tax_identifier: sam_org.tax_identifier_number, tax_identifier_type: sam_org.tax_identifier_type, business_type: "Unknown")
          else
            BdmisMigration.log_failure! line, "Missing Tax Identifier Type or Number in SAM DB"
            next
          end
        end

        if org.has_migrated_bdmis_application?
          update = true
          update = false if line[:last_recommendation] == 'approve'
          update = false if line[:last_recommendation] == 'reject'
          if update
            SbaApplication::EightAMigrated.update! org, STATUS_MAP[line[:last_recommendation]], line
          end
        else
          # new record - make sure you update the existing app and cert here too
          # update existing application and certificate
          # For pre-existing organizations, most likely there will be a vendor admin
          creator = org.vendor_admin_user

          SbaApplication::EightAMigrated.load!(org, line, source_bucket, partial_prefix, creator)
        end
      rescue Exception => e
        BdmisMigration.log_failure! line, "Error caught - #{e.message}"
        next
      end
    end
  end

  def self.retry_import!(line)

    line[:id] = nil
    line[:error_messages] = nil
    line[:sba_application_id] = nil
    line[:approval_date] = line[:approval_date].to_s unless line[:approval_date].nil?
    line[:decline_date] = line[:decline_date].to_s unless line[:decline_date].nil?
    line[:next_review] = line[:next_review].to_s unless line[:next_review].nil?
    line[:exit_date] = line[:exit_date].to_s unless line[:exit_date].nil?
    line[:submitted_on_date] = line[:submitted_on_date].to_s unless line[:submitted_on_date].nil?
    line[:approved_date] = line[:approved_date].to_s unless line[:approved_date].nil?

    sam_org = MvwSamOrganization.get(line[:duns])

    if sam_org.nil?
      BdmisMigration.log_failure! line, "No record found in SAM database for DUNS: #{line[:duns]}"
      return "No record found in SAM database for DUNS"
    end

    org = Organization.find_by(duns_number: line[:duns])
    if org.nil?
      Rails.logger.info "No record found for DUNS - #{line[:duns]} in Certify DB. Proceeding to create record."
      # Prompt if SAM Tax Identifier is different from what's in BDMIS
      if sam_org.tax_identifier_number && sam_org.tax_identifier_type
        org = Organization.create(duns_number: line[:duns], tax_identifier: sam_org.tax_identifier_number, tax_identifier_type: sam_org.tax_identifier_type, business_type: "Unknown")
      else
        BdmisMigration.log_failure! line, "Missing Tax Identifier Type or Number in SAM DB"
        return "Missing Tax Identifier Type or Number in SAM DB"
      end
    end

    if org.has_migrated_bdmis_application?
      update = true
      update = false if line[:last_recommendation] == 'approve'
      update = false if line[:last_recommendation] == 'reject'
      if update
        SbaApplication::EightAMigrated.update! org, STATUS_MAP[line[:last_recommendation]], line
      end
    else
      # new record - make sure you update the existing app and cert here too
      # update existing application and certificate
      # For pre-existing organizations, most likely there will be a vendor admin
      creator = org.vendor_admin_user

      SbaApplication::EightAMigrated.load!(org, line, nil, nil, creator)
    end
  end

  def self.create_sample!(user) # fill it out and submit
     find_by(name: 'eight_a_migrated').start_application(user.one_and_only_org, creator_id: user.id).save!
  end
end
