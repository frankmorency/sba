class MvwSamOrganization < ActiveRecord::Base
  self.table_name = 'mvw_sam_organizations'

  def self.get(duns)
    find_by(duns: duns)
  end

  def self.find_business(search_params)
    if search_params
      where("tax_identifier_number = :ssn_ein AND duns = :duns_number AND mpin = :mpin", ssn_ein: search_params['ssn_ein'], duns_number: search_params['duns_number'], mpin: search_params['mpin']).first
    end
  end

  def self.get_extract_code_by_duns(duns_number)
    where("duns = :duns_number", duns_number: duns_number).select("sam_extract_code")
  end

  def self.sba_analyst_search(query)
    if query.present?
      query = "%#{query}%"
      where("legal_business_name ILIKE ? OR dba_name ILIKE ? OR duns ILIKE ?", query, query, query)
    end
  end

  def self.refresh
    ActiveRecord::Base.connection.execute('REFRESH MATERIALIZED VIEW mvw_sam_organizations')
  end

  def self.get_name_by_duns(duns_number)
    sam_obj = MvwSamOrganization.where("duns = :duns_number", duns_number: duns_number).select('legal_business_name')
    sam_obj.first[:legal_business_name] unless sam_obj.blank?
  end
  
  def self.get_naics_by_duns(duns_number)
    org = MvwSamOrganization.where("duns = :duns_number", duns_number: duns_number).first
    arr = []
    arr = org.naics_code_string.split("~").map(&:chop!) unless org.nil?
    arr
  end

  def self.get_all_cage_codes(duns_number)
    # In SAM table cage codes exist as multiple rows for same duns_number. Rest of the columns are identical
    sam_orgs = MvwSamOrganization.where("duns = :duns_number", duns_number: duns_number)
    cage_codes = sam_orgs.map(&:cage_code).join ', '
  end

  def self.return_snapshot(organization)
    org = where("duns = :duns_number", duns_number: organization.duns_number).first || {}

    snapshot = {
      duns: org["duns"],
      duns_4: org["duns_4"],
      cage_code: get_all_cage_codes(org["duns"]),
      dodaac: org["dodaac"],
      tax_identifier_type: org["tax_identifier_type"],
      tax_identifier_number: org["tax_identifier_number"],
      mpin: org["mpin"],
      sam_extract_code: org["sam_extract_code"],
      legal_business_name: org["legal_business_name"],
      dba_name: org["dba_name"],
      sam_address_1: org["sam_address_1"],
      sam_address_2: org["sam_address_2"],
      sam_city: org["sam_city"],
      sam_province_or_state: org["sam_province_or_state"],
      sam_zip_code_5: org["sam_zip_code_5"],
      sam_zip_code_4: org["sam_zip_code_4"],
      sam_country_code: org["sam_country_code"],
      sam_congressional_district: org["sam_congressional_district"],
      mailing_address_line_1: org["mailing_address_line_1"],
      mailing_address_line_2: org["mailing_address_line_2"],
      mailing_address_city: org["mailing_address_city"],
      mailing_address_zip_code_5: org["mailing_address_zip_code_5"],
      mailing_address_zip_code_4: org["mailing_address_zip_code_4"],
      mailing_address_country: org["mailing_address_country"],
      mailing_address_state_or_province: org["mailing_address_state_or_province"],
      govt_bus_poc_first_name: org["govt_bus_poc_first_name"],
      govt_bus_poc_middle_initial: org["govt_bus_poc_middle_initial"],
      govt_bus_poc_last_name: org["govt_bus_poc_last_name"],
      govt_bus_poc_title: org["govt_bus_poc_title"],
      govt_bus_poc_st_add_1: org["govt_bus_poc_st_add_1"],
      govt_bus_poc_st_add_2: org["govt_bus_poc_st_add_2"],
      govt_bus_poc_city: org["govt_bus_poc_city"],
      govt_bus_poc_zip_code_5: org["govt_bus_poc_zip_code_5"],
      govt_bus_poc_zip_code_4: org["govt_bus_poc_zip_code_4"],
      govt_bus_poc_country_code: org["govt_bus_poc_country_code"],
      govt_bus_poc_state_or_province: org["govt_bus_poc_state_or_province"],
      govt_bus_poc_us_phone: org["govt_bus_poc_us_phone"],
      govt_bus_poc_us_phone_ext: org["govt_bus_poc_us_phone_ext"],
      govt_bus_poc_non_us_phone: org["govt_bus_poc_non_us_phone"],
      govt_bus_poc_fax_us_only: org["govt_bus_poc_fax_us_only"],
      govt_bus_poc_email: org["govt_bus_poc_email"],
      alt_govt_bus_poc_first_name: org["alt_govt_bus_poc_first_name"],
      alt_govt_bus_poc_middle_initial: org["alt_govt_bus_poc_middle_initial"],
      alt_govt_bus_poc_last_name: org["alt_govt_bus_poc_last_name"],
      alt_govt_bus_poc_title: org["alt_govt_bus_poc_title"],
      alt_govt_bus_poc_st_add_1: org["alt_govt_bus_poc_st_add_1"],
      alt_govt_bus_poc_st_add_2: org["alt_govt_bus_poc_st_add_2"],
      alt_govt_bus_poc_city: org["alt_govt_bus_poc_city"],
      alt_govt_bus_poc_zip_code_5: org["alt_govt_bus_poc_zip_code_5"],
      alt_govt_bus_poc_zip_code_4: org["alt_govt_bus_poc_zip_code_4"],
      alt_govt_bus_poc_country_code: org["alt_govt_bus_poc_country_code"],
      alt_govt_bus_poc_state_or_province: org["alt_govt_bus_poc_state_or_province"],
      alt_govt_bus_poc_us_phone: org["alt_govt_bus_poc_us_phone"],
      alt_govt_bus_poc_us_phone_ext: org["alt_govt_bus_poc_us_phone_ext"],
      alt_govt_bus_poc_non_us_phone: org["alt_govt_bus_poc_non_us_phone"],
      alt_govt_bus_poc_fax_us_only: org["alt_govt_bus_poc_fax_us_only"],
      alt_govt_bus_poc_email: org["alt_govt_bus_poc_email"],
      corporate_url: org["corporate_url"],
      primary_naics: org["primary_naics"],
      naics_code_string: org["naics_code_string"],
      business_start_date: org["business_start_date"],
      fiscal_year_end_close_date: org["fiscal_year_end_close_date"],
      expiration_date: org["expiration_date"],
      state_of_incorporation: org["state_of_incorporation"],
      country_of_incorporation: org["country_of_incorporation"],
      average_number_of_employees: org["average_number_of_employees"],
      average_annual_revenue: org["average_annual_revenue"],
      time_of_snapshot: Time.now.to_i
    }
    return snapshot
  end

  def to_org
    # TODO: @org ||= ?
    Organization.find_by(duns_number: duns)
  end

  def has_been_claimed?
    org = to_org
    return false unless org
    return ! to_org.vendor_admin_user.nil?
  end

  def cage_codes
    self.class.get_all_cage_codes(duns)
  end
end
