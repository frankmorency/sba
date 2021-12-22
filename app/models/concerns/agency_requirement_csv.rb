require 'csv'
module AgencyRequirementCSV
  extend ActiveSupport::Concern

  def duty_station_name(x = {})
    self.duty_station&.name
  end

  def agency_co_first_name(x = {})
    self.agency_co&.first_name
  end

  def agency_co_last_name(x = {})
    self.agency_co&.last_name
  end

  def agency_co_address(x = {})
    self.agency_co&.address1
  end

  def agency_co_email(x = {})
    self.agency_co&.email
  end

  def agency_co_phone(x = {})
    self.agency_co&.phone
  end

  def agency_co_city(x = {})
    self.agency_co&.city
  end

  def agency_co_state(x = {})
    self.agency_co&.state
  end

  def agency_co_zip(x = {})
    self.agency_co&.zip
  end

  def agency_poc_title(x = {})
    self.agency_co&.email
  end

  def export_date(x = {})
    Date.today
  end

  def blank_data(x = {})
  end

  def naics_code(x = {})
    self.agency_naics_code&.code
  end

  def size_standard(x = {})
    self.agency_naics_code&.size
  end

  def agency_office_name(x = {})
    self.agency_office&.name
  end

  def contract_type(x = {})
    self.agency_contract_type&.name
  end

  def duns_number(x = {})
    agency_requirement_organizations[x].organization.duns_number
  end

  def firm_name(x = {})
    agency_requirement_organizations[x].organization.to_sam.legal_business_name
  end
  def firm_address(x = {})
    agency_requirement_organizations[x].organization.full_address
  end

  def firm_city(x = {})
    agency_requirement_organizations[x].organization.to_sam.sam_city
  end

  def firm_state(x = {})
    agency_requirement_organizations[x].organization.to_sam.sam_province_or_state
  end

  def firm_zip(x = {})
    agency_requirement_organizations[x].organization.to_sam.sam_zip_code_5
  end

  def firm_owner(x = {})
    agency_requirement_organizations[x].organization.owner_name
  end

  def firm_email(x = {})
    agency_requirement_organizations[x].organization.to_sam.govt_bus_poc_email
  end

  def received_on_csv(x = {})
    received_on
  end

  def unique_number_csv(x = {})
    unique_number
  end

  def estimated_contract_value_csv(x = {})
    estimated_contract_value
  end

  def title_csv(x = {})
    title
  end

  def description_csv(x = {})
    description
  end

  def bos_email(x = {})
    self.user&.email
  end

  def bos_user(x = {})
    self.user&.name
  end

  def agency_offer_code_name
    self.agency_offer_code&.name
  end

  def offer_solicitation_number_csv
    offer_solicitation_number
  end

  def scope
    self.agency_offer_scope&.name
  end

  def agreement
    self.agency_offer_agreement&.name
  end

  def contract_awarded_csv
    contract_awarded
  end

  def sba_program
    self.program&.title
  end

  def contract_value_csv
    contract_value
  end

  def contract_number_csv
    contract_number
  end

  def agency_co_address_2
    self.agency_co&.address2
  end

  def self.search_csv reqs
    header = ["unique_number",
              "title",
              "received_date",
              "naics",
              "size_standard",
              "duty_station",
              "agency_office",
              "agency_offer_code",
              "solicitation_number",
              "scope",
              "agreement",
              "sba_program",
              "agency_contract_type",
              "contract_awarded",
              "estimated_contract_value",
              "contract_value",
              "contract_number",
              "contracting_officer_first_name",
              "contracting_officer_last_name",
              "contracting_officer_phone",
              "contracting_officer_email",
              "contracting_officer_address_1",
              "contracting_officer_address_2",
              "contracting_officer_city",
              "contracting_officer_state",
              "contracting_officer_zip"]

    row = ["unique_number_csv",
           "title_csv",
           "received_on_csv",
           "naics_code",
           "size_standard",
           "duty_station_name",
           "agency_office_name",
           "agency_offer_code_name",
           "offer_solicitation_number_csv",
           "scope",
           "agreement",
           "sba_program",
           "contract_type",
           "contract_awarded_csv",
           "estimated_contract_value_csv",
           "contract_value_csv",
           "contract_number_csv",
           "agency_co_first_name",
           "agency_co_last_name",
           "agency_co_phone",
           "agency_co_email",
           "agency_co_address",
           "agency_co_address_2",
           "agency_co_city",
           "agency_co_state",
           "agency_co_zip"]

    CSV.generate(headers: true) do |csv|
      csv << header
      reqs.each do |requirement_id|
        csv << row.map{ |attr| AgencyRequirement.find(requirement_id).send(attr.to_sym) }
      end
    end

  end

  def to_csv(options = {})

    attributes = ["Contracting Officer First Name", "Contracting Officer Last Name", "Contracting Officer Address", "Contracting Officer City", "Contracting Officer State", "Contracting Officer Zip", "Contracting Officer Email",
                    "Export Date", "Days Since", "Last Template Sent", "Sent On", "Agency POC Title",
                    "Salutation (Mr Or Ms)", "Date Received", "BOS Email Address / User Email Address", "Requirement ID", "NAICS Code", "Size Standard", "Contract Type",
                    "BOS Phone Number", "Agency Name", "Estimated Value of Contract", "Description",
                    "DUNS Number", "Business Name / Firm Name", "Firm Address", "Firm City", "Firm State", "Firm Zip",
                    "Firm POC / Vendor Admin Name", "Firm POC Email / Vendor Admin Email", "BOS Name / User Name", "Duty Station / District Office", "Firm EIN"
                  ]

    row_attributes = %w{agency_co_first_name agency_co_last_name agency_co_address agency_co_city agency_co_state agency_co_zip agency_co_email
                        export_date blank_data blank_data blank_data blank_data blank_data
                        received_on_csv bos_email unique_number_csv naics_code size_standard contract_type
                        blank_data agency_office_name estimated_contract_value_csv description_csv
                        duns_number firm_name firm_address firm_city firm_state firm_zip firm_owner firm_email bos_user duty_station_name blank_data
                      }

    CSV.generate(headers: true) do |csv|
      csv << attributes
      agency_requirement_organizations.each_with_index do |aro, index|
        csv << row_attributes.map{ |attr| self.send(attr.to_sym, index) }
      end
    end
  end
end
