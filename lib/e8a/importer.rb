require 'csv'
require Rails.root.join("app/models/e_8_a_migration.rb")

# This class imports data from the legacy e8a system into Certify. The field mapping between the two systems is defined in
# https://docs.google.com/spreadsheets/d/1qdmAXooQpuwWEGXqOKZJS1VxZE_wHjPjw2zDHO8vzkw/edit?usp=sharing
# The e8a CSV is stored in a S3 bucket
# The field mapping CSVs are stored in db/migrate/e8a
module E8A
  class Importer
    def initialize(bucket_name, file_key)
      @bucket_name = bucket_name
      @file_key = file_key
      @agency_office_map = {}
      @district_office_map = {}
      @agency_contract_type = {"Sole Source" =>"Sole-Source", "Competitive Single" =>"Competitive", "Competitive Multiple" =>"Competitive"}
      @current_row_unique_number = nil
      @fail_count = 0
      @counter = 0
    end

    def load_from_csv!
      read_agency_office_csv
      read_district_office_csv
      read_csv
    end

    def read_csv
      s3 = Aws::S3::Resource.new
      bucket = s3.bucket(@bucket_name)
      csv_contents = bucket.object(@file_key).get.body.string
      CSV.parse(csv_contents, headers: true) do |row|
        @counter += 1
        agency_requirement = AgencyRequirement.new
        agency_requirement.unique_number = @current_row_unique_number = row["RQMTNMB"]

        begin
          agency_requirement.title = row["SUBRQMTCNTRCTDESCTXT"]
          agency_requirement.agency_office = @agency_office_map[row["AGENCYFPDSNM"]] if row["AGENCYFPDSNM"].present?
          agency_requirement.agency_offer_agreement = AgencyOfferAgreement.find_by_name(row["SUBRQMTAGRMTTYPDESCTXT"])
          agency_requirement.agency_offer_scope = AgencyOfferScope.find_by_name(row["SUBRQMTOFFRSCOPEDESCTXT"])
          agency_requirement.agency_contract_type = AgencyContractType.find_by_name(@agency_contract_type[row["RQMTOFFRTYPDESCTXT"]])
          agency_requirement.agency_naics_code = AgencyNaicsCode.find_by_code(row["NAICSCD"]&.strip)
          agency_requirement.duty_station = @district_office_map[row["SBAOFCCD"]&.strip]
          agency_requirement.agency_co = agency_co(row)
          agency_requirement.case_number = row["BUSAPPNMB"] if row["BUSAPPNMB"]
          agency_requirement.received_on = row["SUBRQMTRECVDT"].to_date if row["SUBRQMTRECVDT"]
          agency_requirement.estimated_contract_value = row["SUBRQMTORGLESTAMT"]
          agency_requirement.contract_value = row["SUBRQMTBASEYRESTAMT"]
          agency_requirement.contract_number = row["CNTRCTNMB"]
          agency_requirement.program = program

          AgencyRequirement.skip_callback(:validation, :before, :set_unique_number)
          agency_requirement.save!
          if row["DUNS"].present?
            organization = Organization.from_duns(row["DUNS"].strip)
            agency_requirement.agency_requirement_organizations.build(organization_id: organization.id).save! if organization
          end
          E8aMigration.log_success!(row.to_hash.to_json, @current_row_unique_number)
        rescue Exception => e
          @fail_count += 1
          puts "#{agency_requirement.unique_number} #{e.message}"
          E8aMigration.log_failure!(row.to_hash.to_json, @current_row_unique_number, e.message)
        end

      end

      puts "Total count #{@counter}. Fail Count #{@fail_count}" if Rails.env.development?
      AgencyRequirementsIndex.import #update elasticsearch index
    end

    def read_agency_office_csv
      CSV.foreach(File.join(Rails.root.join("db", "migrate", "e8a", "agency-offices-map.csv")), headers: true) do |row|
        @agency_office_map[row[2]] = AgencyOffice.where("lower(name) = ?", row[4]&.downcase).first ||
            AgencyOffice.where("lower(name) = ?", row[2]&.downcase).first || AgencyOffice.where("lower(name) = ?", row[0]&.downcase).first
      end
    end

    def read_district_office_csv
      CSV.foreach(File.join(Rails.root.join("db", "migrate", "e8a", "district-office-code.csv")), headers: true) do |row|
          @district_office_map[row[0]] = DutyStation.where("lower(name) = ?", row[3]&.strip&.downcase).first
      end
    end

    def agency_co(row)
      if row["RLRECVRNM"].present?
        AgencyCo.new(:first_name => row["RLRECVRNM"], :last_name => row["RLRECVRNM"], :phone => row["RLRECVRPHNNMB"],
                     :address1 => row["RLRECVRSTR1TXT"], :address2 => row["RLRECVRSTR2TXT"], :city => row["RLRECVRCTYNM"],
                     :state => row["STCD"], :zip => row["ZIP5CD"])
      else
        nil
      end
    end

    def program
      Program.find_by_name('eight_a')
    end
  end
end

#importer = E8A::Importer.new("test-requirement-documents", "180913_requirements_last_10_years_master.csv")
#importer.load_from_csv!