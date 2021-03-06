class SamDdl < ActiveRecord::Migration
  def change
    if %w(dev development test build_admin docker qa demo training training_admin).include? Rails.env
      execute <<-SQL
          CREATE TABLE "reference"."sam_organizations"(
          "duns" text,
          "duns_4" text,
          "cage_code" text,
          "dodaac" text,
          "sam_extract_code" text,
          "purpose_of_registration" text,
          "registration_date" text,
          "expiration_date" text,
          "last_update_date" text,
          "activation_date" text,
          "legal_business_name" text,
          "dba_name" text,
          "company_division" text,
          "division_number" text,
          "sam_address_1" text,
          "sam_address_2" text,
          "sam_city" text,
          "sam_province_or_state" text,
          "sam_zip_code_5" text,
          "sam_zip_code_4" text,
          "sam_country_code" text,
          "sam_congressional_district" text,
          "business_start_date" text,
          "fiscal_year_end_close_date" text,
          "company_security_level" text,
          "highest_employee_security_level" text,
          "corporate_url" text,
          "entity_structure" text,
          "state_of_incorporation" text,
          "country_of_incorporation" text,
          "business_type_counter" text,
          "bus_type_string" text,
          "agency_business_purpose" text,
          "primary_naics" text,
          "naics_code_counter" text,
          "naics_code_string" text,
          "psc_code_counter" text,
          "psc_code_string" text,
          "credit_card_usage" text,
          "correspondence_flag" text,
          "mailing_address_line_1" text,
          "mailing_address_line_2" text,
          "mailing_address_city" text,
          "mailing_address_zip_code_5" text,
          "mailing_address_zip_code_4" text,
          "mailing_address_country" text,
          "mailing_address_state_or_province" text,
          "govt_bus_poc_first_name" text,
          "govt_bus_poc_middle_initial" text,
          "govt_bus_poc_last_name" text,
          "govt_bus_poc_title" text,
          "govt_bus_poc_st_add_1" text,
          "govt_bus_poc_st_add_2" text,
          "govt_bus_poc_city" text,
          "govt_bus_poc_zip_code_5" text,
          "govt_bus_poc_zip_code_4" text,
          "govt_bus_poc_country_code" text,
          "govt_bus_poc_state_or_province" text,
          "govt_bus_poc_us_phone" text,
          "govt_bus_poc_us_phone_ext" text,
          "govt_bus_poc_non_us_phone" text,
          "govt_bus_poc_fax_us_only" text,
          "govt_bus_poc_email" text,
          "alt_govt_bus_poc_first_name" text,
          "alt_govt_bus_poc_middle_initial" text,
          "alt_govt_bus_poc_last_name" text,
          "alt_govt_bus_poc_title" text,
          "alt_govt_bus_poc_st_add_1" text,
          "alt_govt_bus_poc_st_add_2" text,
          "alt_govt_bus_poc_city" text,
          "alt_govt_bus_poc_zip_code_5" text,
          "alt_govt_bus_poc_zip_code_4" text,
          "alt_govt_bus_poc_country_code" text,
          "alt_govt_bus_poc_state_or_province" text,
          "alt_govt_bus_poc_us_phone" text,
          "alt_govt_bus_poc_us_phone_ext" text,
          "alt_govt_bus_poc_non_us_phone" text,
          "alt_govt_bus_poc_fax_us_only" text,
          "alt_govt_bus_poc_email" text,
          "past_perf_poc_poc_first_name" text,
          "past_perf_poc_poc_middle_initial" text,
          "past_perf_poc_poc_last_name" text,
          "past_perf_poc_poc_title" text,
          "past_perf_poc_st_add_1" text,
          "past_perf_poc_st_add_2" text,
          "past_perf_poc_city" text,
          "past_perf_poc_code" text,
          "past_perf_poc_zip_code_4" text,
          "past_perf_poc_country_code" text,
          "past_perf_poc_state_or_province" text,
          "past_perf_poc_us_phone" text,
          "past_perf_poc_us_phone_ext" text,
          "past_perf_poc_non_us_phone" text,
          "past_perf_poc_fax_us_only" text,
          "past_perf_poc_email" text,
          "alt_past_perf_poc_first_name" text,
          "alt_past_perf_poc_middle_initial" text,
          "alt_past_perf_poc_last_name" text,
          "alt_past_perf_poc_title" text,
          "alt_past_perf_poc_st_add_1" text,
          "alt_past_perf_poc_st_add_2" text,
          "alt_past_perf_poc_city" text,
          "alt_past_perf_poc_code" text,
          "alt_past_perf_poc_zip_code_4" text,
          "alt_past_perf_poc_country_code" text,
          "alt_past_perf_poc_state_or_province" text,
          "alt_past_perf_poc_us_phone" text,
          "alt_past_perf_poc_us_phone_ext" text,
          "alt_past_perf_poc_non_us_phone" text,
          "alt_past_perf_poc_fax_us_only" text,
          "alt_past_perf_poc_email" text,
          "elec_bus_poc_first_name" text,
          "elec_bus_poc_middle_initial" text,
          "elec_bus_poc_last_name" text,
          "elec_bus_poc_title" text,
          "elec_bus_poc_st_add_1" text,
          "elec_bus_poc_st_add_2" text,
          "elec_bus_poc_city" text,
          "elec_bus_poc_zip_code_5" text,
          "elec_bus_poc_zip_code_4" text,
          "elec_bus_poc_country_code" text,
          "elec_bus_poc_state_or_province" text,
          "elec_bus_poc_us_phone" text,
          "elec_bus_poc_us_phone_ext" text,
          "elec_bus_poc_non_us_phone" text,
          "elec_bus_poc_fax_us_only" text,
          "elec_bus_poc_email" text,
          "alt_elec_poc_bus_poc_first_name" text,
          "alt_elec_poc_bus_poc_middle_initial" text,
          "alt_elec_poc_bus_poc_last_name" text,
          "alt_elec_poc_bus_poc_title" text,
          "alt_elec_poc_bus_st_add_1" text,
          "alt_elec_poc_bus_st_add_2" text,
          "alt_elec_poc_bus_city" text,
          "alt_elec_poc_bus_zip_code_5" text,
          "alt_elec_poc_bus_zip_code_4" text,
          "alt_elec_poc_bus_country_code" text,
          "alt_elec_poc_bus_state_or_province" text,
          "alt_elec_poc_bus_us_phone" text,
          "alt_elec_poc_bus_us_phone_ext" text,
          "alt_elec_poc_bus_non_us_phone" text,
          "alt_elec_poc_bus_fax_us_only" text,
          "alt_elec_poc_bus_email" text,
          "party_performing_certification_poc_first_name" text,
          "party_performing_certification_poc_middle_initial" text,
          "party_performing_certification_poc_last_name" text,
          "party_performing_certification_poc_title" text,
          "party_performing_certification_poc_bus_st_add_1" text,
          "party_performing_certification_poc_bus_st_add_2" text,
          "party_performing_certification_poc_bus_city" text,
          "party_performing_certification_poc_bus_zip_code_5" text,
          "party_performing_certification_poc_bus_zip_code_4" text,
          "party_performing_certification_poc_bus_country_code" text,
          "party_performing_certification_poc_bus_state_or_province" text,
          "party_performing_certification_poc_us_phone" text,
          "party_performing_certification_poc_us_phone_ext" text,
          "party_performing_certification_poc_non_us_phone" text,
          "party_performing_certification_poc_fax_us_only" text,
          "party_performing_certification_poc_email" text,
          "sole_proprietorship_poc_first_name" text,
          "sole_proprietorship_poc_middle_initial" text,
          "sole_proprietorship_poc_last_name" text,
          "sole_proprietorship_poc_title" text,
          "sole_proprietorship_poc_us_phone" text,
          "sole_proprietorship_poc_us_phone_ext" text,
          "sole_proprietorship_poc_non_us_phone" text,
          "sole_proprietorship_poc_fax_us_only" text,
          "sole_proprietorship_poc_email" text,
          "headquarter_parent_poc_(hq)" text,
          "hq_parent_duns_number" text,
          "hq_parent_st_add_1" text,
          "hq_parent_st_add_2" text,
          "hq_parent_city" text,
          "hq_parent_postal_code" text,
          "hq_parent_country_code" text,
          "hq_parent_state_or_province" text,
          "hq_parent_phone" text,
          "domestic_parent_poc_(dm)" text,
          "domestic_parent_duns_number" text,
          "domestic_parent_st_add_1" text,
          "domestic_parent_st_add_2" text,
          "domestic_parent_city" text,
          "domestic_parent_postal_code" text,
          "domestic_parent_country_code" text,
          "domestic_parent_state_or_province" text,
          "domestic_parent_phone" text,
          "global_parent_poc_(gl)" text,
          "global_parent_duns_number" text,
          "global_parent_st_add_1" text,
          "global_parent_st_add_2" text,
          "global_parent_city" text,
          "global_parent_postal_code" text,
          "global_parent_country_code" text,
          "global_parent_state_or_province" text,
          "global_parent_phone" text,
          "dnb_out_of_business_indicator" text,
          "dnb_monitoring_last_updated" text,
          "dnb_monitoring_status" text,
          "dnb_monitoring_legal_business_name" text,
          "dnb_monitoring_dba" text,
          "dnb_monitoring_address_1" text,
          "dnb_monitoring_address_2" text,
          "dnb_monitoring_city" text,
          "dnb_monitoring_postal_code" text,
          "dnb_monitoring_country_code" text,
          "dnb_monitoring_state_or_province" text,
          "edi" text,
          "edi_van_provider" text,
          "isa_qualifier" text,
          "isa_identifier" text,
          "functional_group_identifier" text,
          "820s_request_flag" text,
          "edi_poc_first_name" text,
          "edi_poc_middle_initial" text,
          "edi_poc_last_name" text,
          "edi_poc_title" text,
          "edi_poc_us_phone" text,
          "edi_poc_us_phone_ext" text,
          "edi_poc_non_us_phone" text,
          "edi_poc_fax_us_only" text,
          "edi_poc_email" text,
          "tax_identifier_type" text,
          "tax_identifier_number" text,
          "average_number_of_employees" text,
          "average_annual_revenue" text,
          "financial_institute" text,
          "account_number" text,
          "aba_routing_id" text,
          "account_type" text,
          "lockbox_number" text,
          "authorization_date" text,
          "eft_waiver" text,
          "ach_us_phone" text,
          "ach_non_us_phone" text,
          "ach_fax" text,
          "ach_email" text,
          "remittance_name" text,
          "remittance_address_line_1" text,
          "remittance_address_line_2" text,
          "remittance_city" text,
          "remittance_state_or_province" text,
          "remittance_zip_code_5" text,
          "remittance_zip_code_4" text,
          "remittance_country" text,
          "accounts_receivable_poc_first_name" text,
          "accounts_receivable_poc_middle_initial" text,
          "accounts_receivable_poc_last_name" text,
          "accounts_receivable_poc_title" text,
          "accounts_receivable_poc_us_phone" text,
          "accounts_receivable_poc_us_phone_ext" text,
          "accounts_receivable_poc_non_us_phone" text,
          "accounts_receivable_poc_fax_us_only" text,
          "accounts_receivable_poc_email" text,
          "accounts_payable_poc_first_name" text,
          "accounts_payable_poc_middle_initial" text,
          "accounts_payable_poc_last_name" text,
          "accounts_payable_poc_title" text,
          "accounts_payable_poc_st_add_1" text,
          "accounts_payable_poc_st_add_2" text,
          "accounts_payable_poc_city" text,
          "accounts_payable_poc_zip_code_5" text,
          "accounts_payable_poc_zip_code_4" text,
          "accounts_payable_poc_country_code" text,
          "accounts_payable_poc_state_or_province" text,
          "accounts_payable_poc_us_phone" text,
          "accounts_payable_poc_us_phone_ext" text,
          "accounts_payable_poc_non_us_phone" text,
          "accounts_payable_poc_fax_us_only" text,
          "accounts_payable_poc_email" text,
          "mpin" text,
          "naics_exception_counter" text,
          "naics_exception_string" text,
          "delinquent_federal_debt_flag" text,
          "exclusion_status_flag" text,
          "sba_business_types_counter" text,
          "sba_business_types_string" text,
          "sam_numerics_counter" text,
          "sam_numerics_code_string" text,
          "no_public_display_flag" text,
          "disaster_response_counter" text,
          "disaster_response_string" text,
          "annual_igt_revenue" text,
          "agency_location_code" text,
          "disbursing_office_symbol" text,
          "merchant_id_1" text,
          "merchant_id_2" text,
          "accounting_station" text,
          "source" text,
          "department_code" text,
          "hierarchy_department_code" text,
          "hierarchy_department_name" text,
          "hierarchy_agency_code" text,
          "hierarchy_agency_name" text,
          "hierarchy_office_code" text,
          "eliminations_poc_first_name" text,
          "eliminations_poc_middle_initial" text,
          "eliminations_poc_last_name" text,
          "eliminations_poc_title" text,
          "eliminations_poc_st_add_1" text,
          "eliminations_poc_st_add_2" text,
          "eliminations_poc_city" text,
          "eliminations_poc_zip_code_5" text,
          "eliminations_poc_zip_code_4" text,
          "eliminations_poc_country_code" text,
          "eliminations_poc_state_or_province" text,
          "eliminations_poc_us_phone" text,
          "eliminations_poc_us_phone_ext" text,
          "eliminations_poc_non_us_phone" text,
          "eliminations_poc_fax_us_only" text,
          "eliminations_poc_email" text,
          "sales_poc_first_name" text,
          "sales_poc_middle_initial" text,
          "sales_poc_last_name" text,
          "sales_poc_title" text,
          "sales_poc_st_add_1" text,
          "sales_poc_st_add_2" text,
          "sales_poc_city" text,
          "sales_poc_zip_code_5" text,
          "sales_poc_zip_code_4" text,
          "sales_poc_country_code" text,
          "sales_poc_state_or_province" text,
          "sales_poc_us_phone" text,
          "sales_poc_us_phone_ext" text,
          "sales_poc_non_us_phone" text,
          "sales_poc_fax_us_only" text,
          "sales_poc_email" text,
          "record_create_dt" timestamp,
          "record_update_dt" timestamp);

          CREATE materialized view reference.mvw_sam_organizations as
            select
              duns,
              duns_4,
              cage_code,
              dodaac,
              tax_identifier_number,
              (case when tax_identifier_type = '1' then 'SSN'
                    when tax_identifier_type = '2' then 'EIN'
                    else 'UnKnown'END) AS tax_identifier_type,
                mpin,
                sam_extract_code,
                legal_business_name,
                dba_name,
                sam_address_1,
                sam_address_2,
                sam_city,
                sam_province_or_state,
                sam_zip_code_5,
                sam_zip_code_4,
                sam_country_code,
                sam_congressional_district,
                mailing_address_line_1,
                mailing_address_line_2,
                mailing_address_city,
                mailing_address_zip_code_5,
                mailing_address_zip_code_4,
                mailing_address_country,
                mailing_address_state_or_province,
                govt_bus_poc_first_name,
                govt_bus_poc_middle_initial,
                govt_bus_poc_last_name,
                govt_bus_poc_title,
                govt_bus_poc_st_add_1,
                govt_bus_poc_st_add_2,
                govt_bus_poc_city,
                govt_bus_poc_zip_code_5,
                govt_bus_poc_zip_code_4,
                govt_bus_poc_country_code,
                govt_bus_poc_state_or_province,
                govt_bus_poc_us_phone,
                govt_bus_poc_us_phone_ext,
                govt_bus_poc_non_us_phone,
                govt_bus_poc_fax_us_only,
                govt_bus_poc_email,
                alt_govt_bus_poc_first_name,
                alt_govt_bus_poc_middle_initial,
                alt_govt_bus_poc_last_name,
                alt_govt_bus_poc_title,
                alt_govt_bus_poc_st_add_1,
                alt_govt_bus_poc_st_add_2,
                alt_govt_bus_poc_city,
                alt_govt_bus_poc_zip_code_5,
                alt_govt_bus_poc_zip_code_4,
                alt_govt_bus_poc_country_code,
                alt_govt_bus_poc_state_or_province,
                alt_govt_bus_poc_us_phone,
                alt_govt_bus_poc_us_phone_ext,
                alt_govt_bus_poc_non_us_phone,
                alt_govt_bus_poc_fax_us_only,
                alt_govt_bus_poc_email,
                corporate_url,
                primary_naics,
                naics_code_string,
                business_start_date,
                fiscal_year_end_close_date,
                expiration_date,
                state_of_incorporation,
                country_of_incorporation,
                average_number_of_employees,
                average_annual_revenue
              from reference.sam_organizations
              where sam_extract_code in ('A', 'E', 'D');

          create unique index "idx_mvw_sam_organizations" on reference.mvw_sam_organizations("duns", "duns_4", "cage_code", "dodaac");
          create index "idx_mvw_sam_organizations_2" on reference.mvw_sam_organizations(duns, tax_identifier_number, tax_identifier_type, mpin, sam_extract_code);
      SQL
    end
  end
end
