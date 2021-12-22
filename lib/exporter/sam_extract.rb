module Exporter
  class SamExtract < Base
    protected

    def row_converter(row)
      row['duns'] = row['duns']&.rjust(9, '0')
      row['duns_4'] = row['duns_4']&.rjust(4, '0')
      row['tax_identifier_number'] = row['tax_identifier_number']&.rjust(9, '0')
      row['sam_zip_code_5'] = row['sam_zip_code_5']&.rjust(5, '0')
      row['sam_zip_code_4'] = row['sam_zip_code_4']&.rjust(5, '0')
      row['govt_bus_poc_zip_code_5'] = row['govt_bus_poc_zip_code_5']&.rjust(5, '0')
      row['govt_bus_poc_zip_code_4'] = row['govt_bus_poc_zip_code_4']&.rjust(5, '0')

      row
    end

    def query
      <<~QUERY
        SET search_path TO sbaone;
        SELECT
          sam.duns, duns_4, cage_code, dodaac, tax_identifier_number, tax_identifier_type,
          sam_extract_code, legal_business_name, dba_name, sam_address_1, sam_address_2,
          sam_city, sam_province_or_state, sam_zip_code_5, sam_zip_code_4, sam_country_code,
          sam_congressional_district, mailing_address_line_1, mailing_address_line_2,
          mailing_address_city, mailing_address_zip_code_5, mailing_address_zip_code_4,
          mailing_address_country, mailing_address_state_or_province, govt_bus_poc_first_name,
          govt_bus_poc_middle_initial, govt_bus_poc_last_name, govt_bus_poc_title,
          govt_bus_poc_st_add_1, govt_bus_poc_st_add_2, govt_bus_poc_city, govt_bus_poc_zip_code_5,
          govt_bus_poc_zip_code_4, govt_bus_poc_country_code, govt_bus_poc_state_or_province,
          govt_bus_poc_us_phone, govt_bus_poc_us_phone_ext, govt_bus_poc_non_us_phone,
          govt_bus_poc_fax_us_only, govt_bus_poc_email, alt_govt_bus_poc_first_name,
          alt_govt_bus_poc_middle_initial, alt_govt_bus_poc_last_name, alt_govt_bus_poc_title, alt_govt_bus_poc_st_add_1, alt_govt_bus_poc_st_add_2, alt_govt_bus_poc_city, alt_govt_bus_poc_zip_code_5,
          alt_govt_bus_poc_zip_code_4, alt_govt_bus_poc_country_code, alt_govt_bus_poc_state_or_province,
          alt_govt_bus_poc_us_phone, alt_govt_bus_poc_us_phone_ext, alt_govt_bus_poc_non_us_phone,
          alt_govt_bus_poc_fax_us_only, alt_govt_bus_poc_email, corporate_url, primary_naics,
          naics_code_string, business_start_date, fiscal_year_end_close_date, expiration_date,
          state_of_incorporation, country_of_incorporation, average_number_of_employees,
          average_annual_revenue,
        (
          SELECT cert.workflow_state
          FROM certificates AS cert
          WHERE cert.certificate_type_id = '4' AND cert.deleted_at IS NULL AND cert.organization_id = org.id
          ORDER BY cert.id DESC limit 1
        ) AS "eight_a",
        (
          SELECT cert.workflow_state
          FROM certificates AS cert
          WHERE cert.certificate_type_id = '1' AND cert.deleted_at IS NULL AND cert.organization_id = org.id
          ORDER BY cert.id DESC limit 1
        ) as "wosb",
        (
          SELECT
          cert.workflow_state
          FROM certificates as cert
          WHERE cert.certificate_type_id = '2' AND cert.deleted_at IS NULL AND cert.organization_id = org.id
          ORDER BY cert.id DESC limit 1
        ) as "edwosb",
        (
          SELECT cert.workflow_state
          FROM sbaone.certificates as cert
          WHERE cert.certificate_type_id = '3' AND cert.deleted_at IS NULL AND cert.organization_id = org.id
          order by cert.id DESC limit 1
        ) as "all_smalls_mpp"
        FROM (SELECT DISTINCT duns_number, id FROM organizations) AS org
        INNER JOIN reference.mvw_sam_organizations AS sam
          ON org.duns_number = sam.duns;
      QUERY
    end

    def headers
      %w(
        duns duns_4 cage_code dodaac tax_identifier_number tax_identifier_type sam_extract_code
        legal_business_name dba_name sam_address_1 sam_address_2 sam_city sam_province_or_state
        sam_zip_code_5 sam_zip_code_4 sam_country_code sam_congressional_district mailing_address_line_1
        mailing_address_line_2 mailing_address_city mailing_address_zip_code_5 mailing_address_zip_code_4
        mailing_address_country mailing_address_state_or_province govt_bus_poc_first_name
        govt_bus_poc_middle_initial govt_bus_poc_last_name govt_bus_poc_title govt_bus_poc_st_add_1 govt_bus_poc_st_add_2 govt_bus_poc_city govt_bus_poc_zip_code_5 govt_bus_poc_zip_code_4
        govt_bus_poc_country_code govt_bus_poc_state_or_province govt_bus_poc_us_phone govt_bus_poc_us_phone_ext
        govt_bus_poc_non_us_phone govt_bus_poc_fax_us_only govt_bus_poc_email alt_govt_bus_poc_first_name
        alt_govt_bus_poc_middle_initial alt_govt_bus_poc_last_name alt_govt_bus_poc_title alt_govt_bus_poc_st_add_1
        alt_govt_bus_poc_st_add_2 alt_govt_bus_poc_city alt_govt_bus_poc_zip_code_5 alt_govt_bus_poc_zip_code_4
        alt_govt_bus_poc_country_code alt_govt_bus_poc_state_or_province alt_govt_bus_poc_us_phone
        alt_govt_bus_poc_us_phone_ext alt_govt_bus_poc_non_us_phone alt_govt_bus_poc_fax_us_only
        alt_govt_bus_poc_email corporate_url primary_naics naics_code_string business_start_date
        fiscal_year_end_close_date expiration_date state_of_incorporation country_of_incorporation
        average_number_of_employees average_annual_revenue eight_a wosb edwosb all_smalls_mpp
      )
    end
  end
end
