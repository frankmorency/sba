class Reload8aSpouseQuestionnaire < ActiveRecord::Migration
  def change

    
    Questionnaire.get('eight_a_spouse').destroy

    CertificateType.create!(name: 'eight_a_spouse', title: '8(a) Spouse')
    spouse = Questionnaire::SubQuestionnaire.create! name: 'eight_a_spouse', title: '8(a) Spouse', anonymous: false, program: Program.get('eight_a'), certificate_type: CertificateType.get('eight_a_spouse'), review_page_display_title: '8(a) Spouse'

    spouse.create_sections! do
      root 'eight_a_spouse', 1, title: '8(a) Spouse' do
        question_section 'eight_a_spouse_general_information', 1, title: 'General Information', submit_text: 'Save and continue' do
          question_section 'eight_a_spouse_gender', 0, title: 'Gender', first: true do
            picklist 'gender', 1, title: 'Legal Gender', possible_values: ['Female', 'Male']
          end
          question_section 'eight_a_spouse_marital_status', 1, title: 'Marital Status' do
            picklist_with_radio_buttons_with_attachment_required_on_last_radio_button 'eight_a_marital_status', 1, title: 'Marital Status', possible_values: ['Unmarried', 'Married', 'Legally Separated']
          end
          question_section 'eight_a_spouse_social_security_number', 2, title: 'Social Security Number' do
            text_field_single_line 'social_security_number', 1, title: 'Social Security Number'
          end
          question_section 'eight_a_spouse_contact_information', 3, title: 'Contact Information' do
            text_field_single_line 'phone_number', 1, title: 'Best contact phone number'
          end
          question_section 'eight_a_spouse_current_home_address', 4, title: 'Current Home Address' do
            full_address 'current_home_address', 1, title: 'Provide your current home address'
            date 'eight_a_current_home_dates_of_residency', 2, title: 'Dates of Residency'
          end

          question_section 'eight_a_spouse_role', 5, title: 'Role in Applicant Firm' do
            yesno 'spouse_role', 1, title: 'Do you own 10% or more of the Applicant Firm or act as a director, management member, partner, or officer?'
          end

          question_section 'eight_a_length_of_residency', 6, title: 'Length of residency' do
            yesno 'length_of_residency', 1, title: 'Have you lived at your present address more than 10 years?'
          end

          question_section 'eight_a_spouse_previous_home_address', 7, title: 'Previous Home Address' do
            yesno 'previous_home_residency', 1, title: 'Have you lived at your present address more than 10 years?'
            full_address 'previous_home_address', 2, title: 'Provide your most recent previous home address'
            date_range 'eight_a_previous_home_dates_of_residency', 3, title: 'Dates of Residency'
          end

          question_section 'eight_a_spouse_date_place_of_birth', 8, title: 'Date and Place of Birth' do
            date 'date_of_birth', 1, title: 'Date of Birth'
            text_field_single_line 'place_of_birth', 2, title: 'Place of Birth'
            picklist 'country_of_birth', 3, title: 'Country of Birth', possible_values: Country.pluck(:name).unshift('United States').uniq
          end

          question_section 'eight_a_spouse_us_citizenship', 9, title: 'U.S. Citizenship' do
            question 'us_citizen', 1, title: 'Are you a U.S. Citizen?'
          end
          question_section 'eight_a_spouse_resident_alien', 10, title: 'Resident Alien' do
            yesno_with_comment_required 'resident_alien', 1, title: 'Are you a Lawful Permanent Resident Alien?'
          end
        end
        question_section 'eight_a_spouse_resume', 2, title: 'Resume', submit_text: 'Save and continue' do
          question_section 'eight_a_spouse_upload_resume', 1, title: 'Upload Resume' do
            null_with_attachment_required 'eight_a_upload_resume', 1, title: 'Upload your personal resume.'
          end
        end
        question_section 'eight_a_spouse_ownership_control', 3, title: 'Ownership and Control', submit_text: 'Save and continue' do
          question_section 'eight_a_spouse_applicant_firm_ownership', 1, title: 'Applicant Firm Ownership' do
            percentage 'percentage', 1, title: 'What percentage of the Applicant Firm do you own?'
            text_field_multiline 'all_positions_with_firm', 2, title: 'List all positions you hold in the Applicant Firm.'
          end
          question_section 'eight_a_spouse_bank_account_access', 2, title: 'Bank Account Access' do
            yesno_with_comment_optional_on_yes 'eight_a_bank_account_access', 1, title: "Are you authorized to access or make withdrawals from the Applicant Firm’s bank account?"
          end
          question_section 'eight_a_spouse_prior_ownership', 3, title: 'Prior Ownership' do
            yesno_with_comment_required_on_yes 'former_employer', 1, title: "Are you the former employer of the Individual Claiming Disadvantage?"
            yesno_with_attachment_required_on_yes 'former_majority_owner', 2, title: 'Are you the former majority owner (51% or more) of the Applicant Firm?'
          end
          question_section 'eight_a_spouse_business_affiliations', 4, title: 'Business Affiliations' do
            yesno_with_attachment_required_on_yes 'eight_a_business_affiliations', 1, title: 'Do you own or work for any other firm that has a relationship with the Applicant Firm?'
            yesno_with_comment_required_on_yes 'eight_a_family_contractual_affiliation', 2, title: 'Do any of your immediate family members own a firm with a contractual relationship with the Applicant Firm?'
          end
        end
        question_section 'eight_a_spouse_8a_eligibility', 4, title: '8(a) Program Eligibility', submit_text: 'Save and continue' do
          question_section 'eight_a_spouse_prior_involvement', 1, title: 'Prior 8a Involvement' do
            yesno_with_attachment_required_on_yes 'eight_a_eligibility_q0', 1, title: 'Have you – or any firm you owned – ever applied for 8(a) Certification or participated in the 8(a) Program?'
            yesno 'eight_a_eligibility_q1', 2, title: 'Have you already used your one-time-only 8(a) eligibility to qualify a business for the 8(a) Program?'
            yesno_with_attachment_required_on_yes 'eight_a_eligibility_q2', 3, title: 'Have any of your immediate family members ever owned a firm that was admitted to the 8(a) Program?'
          end
          question_section 'eight_a_spouse_federal_employment', 2, title: 'Federal Employment' do
            yesno_with_attachment_required_on_yes 'eight_a_federal_employment_q0', 1, title: 'Are you a Federal Government employee holding a position of GS-13 or above?'
          end
        end
        question_section 'eight_a_spouse_character', 5, title: 'Character', submit_text: 'Save and continue' do
          question_section 'eight_a_spouse_financial', 1, title: 'Financial' do
            yesno_with_attachment_required_on_yes 'eight_a_financial_q0', 1, title: 'Have you filed for personal bankruptcy within the past 7 years?'
            yesno_with_attachment_required_on_yes 'eight_a_financial_q1', 2, title: 'Have you previously obtained an SBA loan?'
            yesno_with_attachment_required_on_yes 'eight_a_financial_q2', 3, title: 'Are you a party to a pending civil lawsuit?'
            yesno_with_attachment_required_on_yes 'eight_a_financial_q3', 4, title: 'Are you delinquent in paying or filing any of the following:<ul><li>Federal or Federally guaranteed obligations (including Federal student loans)</li><li>Business taxes or liens</li><li>Personal Federal, State, or local tax returns</li></ul>'
          end
          question_section 'eight_a_spouse_criminal_history', 2, title: 'Criminal History' do
            yesno_with_comment_required_on_yes 'eight_a_criminal_history_q0', 1, title: 'Have you ever gone by any other names?'
            yesno 'eight_a_criminal_history_q1', 2, title: 'Are you presently subject to an indictment, criminal information, arraignment, or other means by which formal criminal charges are brought in any jurisdiction? '
            yesno 'eight_a_criminal_history_q2', 3, title: 'Have you been arrested in the past six months for any criminal offense?'
            yesno 'eight_a_criminal_history_q3', 4, title: 'For any criminal offense – other than a minor vehicle violation – have you ever: <ul><li>Been convicted</li><li>Plead guilty</li><li>Plead nolo contendere</li><li>Been placed on pretrial diversion</li><li>Been placed on any form of parole or probation (including probation before judgment)</li></ul>'
          end
          question_section 'eight_a_spouse_criminal_history_documentation', 3, title: 'Criminal History Documentation' do
            null_with_attachment_required 'criminal_history_doc_q0', 1, title: 'Upload a narrative for EACH “YES” answer.'
            null_with_attachment_required 'criminal_history_doc_q1', 2, title: 'Upload copies of all relevant court dispositions or documents.'
            null_with_attachment_required 'criminal_history_doc_q2', 3, title: 'Upload a completed Form FD-258 Fingerprint Card.'
          end
        end
        question_section 'eight_a_spouse_economic_disadvantage', 6, title: 'Economic Disadvantage', submit_text: 'Save and continue' do
          question_section 'eight_a_spouse_tax_returns', 1, title: 'Tax Returns' do
            null_with_attachment_required 'eight_a_tax_ret', 1, title: 'Upload your personal Federal tax returns from the last three years including all schedules and attachments.'
          end
          question_section 'eight_a_financial_data', 2, title: 'Financial Data' do
            question_section 'cash_on_hand', 0, title: 'Cash On Hand' do
              date 'edwosb_cash_as_of_date', 1, title: 'As of Date: '
              currency 'edwosb_cash_on_hand', 2, title: 'Cash on Hand'
              currency 'edwosb_savings_balance', 3, title: 'Savings Account(s) Balance'
              currency 'edwosb_checking_balance', 4, title: 'Checking Account(s) Balance'
            end
            question_section 'other_sources_of_income', 1, title: 'Other Sources Of Income' do
              currency 'edwosb_salary', 1, title: 'Salary'
              currency_with_comment_required_on_positive_value 'edwosb_other_income_comment', 2, title: 'Other Income'
              currency 'edwosb_biz_equity', 3, title: 'Applicant’s Business Equity'
              currency 'edwosb_equity_in_other_firms', 4, title: 'Applicant’s Equity in Other Firms'
            end
            question_section 'notes_receivable', 2, title: 'Notes Receivable' do
              yesno_with_table_required_on_yes 'notes_receivable', 1, title: 'Do you have any notes receivable from others?', strategy: "NotesReceivables"
            end
            question_section 'retirement_accounts', 3, title: 'Retirement Accounts' do
              yesno_with_table_required_on_yes 'roth_ira', 1, title: 'Do you have a Roth IRA?', strategy: "Retirement"
              yesno_with_table_required_on_yes 'other_retirement_accounts', 2, title: 'Do you have any other retirement accounts?', strategy: "Retirement"
            end
            question_section 'life_insurance', 4, title: 'Life Insurance', validation_rules: { toggle: { life_insurance_loans: {show_on: 'yes', dependent: 'life_insurance_loan_value', clear_on_hide: true } } } do
              yesno_with_table_required_on_yes 'life_insurance_cash_surrender', 0, title: 'Do you have a life insurance policy that has a Cash Surrender Value?', strategy: "LifeInsurance"
              yesno 'life_insurance_loans', 1, title: 'Do you have any loans against a life insurance policy?'
              currency 'life_insurance_loan_value', 2, title: 'What is the current balance of any loans against life insurance?', validation_rules: {required: false}
            end
            question_section 'stocks_bonds', 5, title: 'Stocks & Bonds' do
              yesno_with_table_required_on_yes 'stocks_bonds', 1, title: 'Do you have any stocks, bonds or Mutual Funds?', strategy: "StocksAndBonds"
            end
            real_estate_section 'real_estate_primary', 6, title: 'Real Estate - Primary Residence', template_type: 'Section::RealEstateSection' do
              yesno 'has_primary_real_estate', 1, title: 'Do you own your primary residence?'
              # HACK: Positions are important here - they start at 0 so the javascript will work in real_estate_sub_question.slim
              real_estate 'primary_real_estate', 2, title: 'Primary Residence Details', multi: false, sub_questions: [
                  {
                      question_type: 'address', name: 'real_estate_address', position: 1, title: 'What is the address of your primary residence?'
                  },
                  {
                      question_type: 'yesno', name: 'real_estate_jointly_owned', position: 2, title: 'Is your primary residence jointly owned?'
                  },
                  {
                      question_type: 'percentage', name: 'real_estate_jointly_owned_percent', position: 3, title: 'What percentage of ownership do you have in your primary residence?'
                  },
                  {
                      question_type: 'percentage', name: 'real_estate_percent_of_mortgage', position: 4, title: 'What percentage of the mortgage are you responsible for in your primary residence?'
                  },
                  {
                      question_type: 'yesno', name: 'real_estate_name_on_mortgage', position: 5, title: 'Is your name on the mortgage?'
                  },
                  {
                      question_type: 'currency', name: 'real_estate_value', position: 6, title: 'What is the current value of your primary residence?'
                  },
                  {
                      question_type: 'currency', name: 'real_estate_mortgage_balance', position: 7, title: 'What is the mortgage balance on your primary residence?'
                  },
                  {
                      question_type: 'yesno', name: 'real_estate_second_mortgage', position: 8, title: 'Is there a lien, 2nd mortgage or Home Equity Line of Credit on your primary residence?'
                  },
                  {
                      question_type: 'yesno', name: 'real_estate_second_mortgage_your_name', position: 9, title: 'Is your name on the lien, 2nd mortgage or Home Equity Line of Credit against your primary residence?'
                  },
                  {
                      question_type: 'percentage', name: 'real_estate_second_mortgage_percent', position: 10, title: 'What percentage of the lien, 2nd mortgage or Home Equity Line of Credit are you responsible for in your primary residence?'
                  },
                  {
                      question_type: 'currency', name: 'real_estate_second_mortgage_value', position: 11, title: 'What is the current balance of the lien(s)?'
                  },
                  {
                      question_type: 'yesno', name: 'real_estate_rent_income', position: 12, title: 'Do you receive income from your primary residence (rent, etc.)?'
                  },
                  {
                      question_type: 'currency', name: 'real_estate_rent_income_value', position: 13, title: 'What is the income YOU receive from your primary residence (calculated annually)?'
                  }
              ]
            end
            real_estate_section 'real_estate_other', 7, title: 'Real Estate - Other', template_type: 'Section::RealEstateSection' do
              yesno 'has_other_real_estate', 1, title: 'Do you own any additional real estate?'
              # HACK: Positions are important here - they start at 0 so the javascript will work in real_estate_sub_question.slim
              real_estate 'other_real_estate', 2, title: 'List your other real estate holdings:', multi: true, sub_questions: [
                  {
                      question_type: 'picklist', name: 'real_estate_type', position: 0, title: 'What type of Other Real Estate do you own?', possible_values: ['Other Residential', 'Commercial', 'Industrial', 'Land', 'Other Real Estate']
                  },
                  {
                      question_type: 'address', name: 'real_estate_address', position: 1, title: 'What is the address of your Other Real Estate?'
                  },
                  {
                      question_type: 'yesno', name: 'real_estate_jointly_owned', position: 2, title: 'Is your Other Real Estate jointly owned?'
                  },
                  {
                      question_type: 'percentage', name: 'real_estate_jointly_owned_percent', position: 3, title: 'What percentage of ownership do you have in your Other Real Estate?'
                  },
                  {
                      question_type: 'yesno', name: 'real_estate_name_on_mortgage', position: 4, title: 'Is your name on the mortgage?'
                  },
                  {
                      question_type: 'percentage', name: 'real_estate_percent_of_mortgage', position: 5, title: 'What percentage of the mortgage are you responsible for in your Other Real Estate?'
                  },
                  {
                      question_type: 'currency', name: 'real_estate_value', position: 6, title: 'What is the current value of your Other Real Estate?'
                  },
                  {
                      question_type: 'currency', name: 'real_estate_mortgage_balance', position: 7, title: 'What is the mortgage balance on your Other Real Estate?'
                  },
                  {
                      question_type: 'yesno', name: 'real_estate_second_mortgage', position: 8, title: 'Is there a lien, 2nd mortgage or Home Equity Line of Credit on your Other Real Estate?'
                  },
                  {
                      question_type: 'yesno', name: 'real_estate_second_mortgage_your_name', position: 9, title: 'Is your name on the lien, 2nd mortgage or Home Equity Line of Credit against your other real estate?'
                  },
                  {
                      question_type: 'percentage', name: 'real_estate_second_mortgage_percent', position: 10, title: 'What percentage of the lien, 2nd mortgage or Home Equity Line of Credit are you responsible for in your other real estate?'
                  },
                  {
                      question_type: 'currency', name: 'real_estate_second_mortgage_value', position: 11, title: 'What is the current balance of the lien(s)?'
                  },
                  {
                      question_type: 'yesno', name: 'real_estate_rent_income', position: 12, title: 'Do you receive income from your Other Real Estate (rent, etc.)?'
                  },
                  {
                      question_type: 'currency', name: 'real_estate_rent_income_value', position: 13, title: 'What is the income YOU receive from your Other Real Estate (calculated annually)?'
                  }
              ]
            end
            question_section 'personal_property', 8, title: 'Personal Property' do
              yesno_with_table_required_on_yes 'automobiles', 1, title: 'Do you own any automobiles?', strategy: "PersonalProperty"
              yesno_with_table_required_on_yes 'other_personal_property', 4, title: 'Do you own any other personal property or assets?', strategy: "PersonalProperty"
            end
            question_section 'notes_payable', 9, title: 'Notes Payable and Other Liabilities' do
              yesno_with_table_required_on_yes 'notes_payable', 1, title: 'Do you have any notes payable?', strategy: "NotesPayable"
            end
            question_section 'assessed_taxes', 10, title: 'Assessed Taxes' do
              yesno_with_table_required_on_yes 'assessed_taxes', 1, title: 'Do you have any Assessed Taxes that were unpaid?', strategy: 'AssessedTaxes'
            end
            personal_summary 'personal_summary', 11, title: 'Personal Summary', template_type: 'Section::PersonalSummary'
            personal_privacy 'personal_privacy', 12, title: 'Privacy Statements', template_type: 'Section::PersonalPrivacy'
          end
        end
        review_section 'review', 7, title: 'Review', submit_text: 'Submit'
        signature_section 'signature', 8, title: 'Signature'
      end
    end

    spouse.create_rules! do
      section_rule 'eight_a_spouse_gender', 'eight_a_spouse_marital_status'
      section_rule 'eight_a_spouse_marital_status', 'eight_a_spouse_social_security_number'
      section_rule 'eight_a_spouse_social_security_number', 'eight_a_spouse_contact_information'
      section_rule 'eight_a_spouse_contact_information', 'eight_a_spouse_current_home_address'
      section_rule 'eight_a_spouse_current_home_address', 'eight_a_spouse_role'

      section_rule 'eight_a_spouse_role', 'eight_a_length_of_residency', {
          klass: 'Answer', identifier: 'spouse_role', value: 'yes'
      }
      section_rule 'eight_a_spouse_role', 'eight_a_spouse_tax_returns', {
          klass: 'Answer', identifier: 'spouse_role', value: 'no'
      }

      section_rule 'eight_a_length_of_residency', 'eight_a_spouse_previous_home_address', {
          klass: 'Answer', identifier: 'length_of_residency', value: 'no'
      }
      section_rule 'eight_a_length_of_residency', 'eight_a_spouse_date_place_of_birth', {
          klass: 'Answer', identifier: 'length_of_residency', value: 'yes'
      }

      section_rule 'eight_a_spouse_previous_home_address', 'eight_a_spouse_date_place_of_birth'

      section_rule 'eight_a_spouse_date_place_of_birth', 'eight_a_spouse_us_citizenship'

      section_rule 'eight_a_spouse_us_citizenship', 'eight_a_spouse_resident_alien', {
          klass: 'Answer', identifier: 'us_citizen', value: 'no'
      }
      section_rule 'eight_a_spouse_us_citizenship', 'eight_a_spouse_upload_resume', {
          klass: 'Answer', identifier: 'us_citizen', value: 'yes'
      }
      section_rule 'eight_a_spouse_resident_alien', 'eight_a_spouse_upload_resume'
      section_rule 'eight_a_spouse_upload_resume', 'eight_a_spouse_applicant_firm_ownership'
      section_rule 'eight_a_spouse_applicant_firm_ownership', 'eight_a_spouse_bank_account_access'
      section_rule 'eight_a_spouse_bank_account_access', 'eight_a_spouse_prior_ownership'
      section_rule 'eight_a_spouse_prior_ownership', 'eight_a_spouse_business_affiliations'
      section_rule 'eight_a_spouse_business_affiliations', 'eight_a_spouse_prior_involvement'
      section_rule 'eight_a_spouse_prior_involvement', 'eight_a_spouse_federal_employment'
      section_rule 'eight_a_spouse_federal_employment', 'eight_a_spouse_financial'
      section_rule 'eight_a_spouse_financial', 'eight_a_spouse_criminal_history'
      section_rule 'eight_a_spouse_criminal_history', 'eight_a_spouse_criminal_history_documentation', {
          klass: 'Answer', identifier: 'eight_a_criminal_history_q0', value: 'yes'
      }
      section_rule 'eight_a_spouse_criminal_history', 'eight_a_spouse_criminal_history_documentation', {
          klass: 'Answer', identifier: 'eight_a_criminal_history_q1', value: 'yes'
      }
      section_rule 'eight_a_spouse_criminal_history', 'eight_a_spouse_criminal_history_documentation', {
          klass: 'Answer', identifier: 'eight_a_criminal_history_q2', value: 'yes'
      }
      section_rule 'eight_a_spouse_criminal_history', 'eight_a_spouse_criminal_history_documentation', {
          klass: 'Answer', identifier: 'eight_a_criminal_history_q3', value: 'yes'
      }
      section_rule 'eight_a_spouse_criminal_history', 'eight_a_spouse_tax_returns'
      section_rule 'eight_a_spouse_criminal_history_documentation', 'eight_a_spouse_tax_returns'

      section_rule 'eight_a_spouse_tax_returns', 'cash_on_hand'
      section_rule 'cash_on_hand', 'other_sources_of_income'
      section_rule 'other_sources_of_income', 'notes_receivable'
      section_rule 'notes_receivable', 'retirement_accounts'
      section_rule 'retirement_accounts', 'life_insurance'
      section_rule 'life_insurance', 'stocks_bonds'
      section_rule 'stocks_bonds', 'real_estate_primary'
      section_rule 'real_estate_primary', 'real_estate_other'
      section_rule 'real_estate_other', 'personal_property'
      section_rule 'personal_property', 'notes_payable'
      section_rule 'notes_payable', 'assessed_taxes'
      section_rule 'assessed_taxes', 'personal_summary'
      section_rule 'personal_summary', 'personal_privacy'
      section_rule 'personal_privacy', 'review'
      section_rule 'review', 'signature'
    end

    Section.where(questionnaire_id: Questionnaire.get('eight_a_spouse').id, name: 'signature').update_all is_last: true

    SectionRule.where(to_section_id: Section.where(name: 'review').pluck(:id)).each do |rule|
      if rule.from_section.name == 'form413' || rule.from_section.name =~ /^personal_privacy_/
        # Rails.logger.warn("APP320 - Updating rule (#{rule.debug}) to set is_last to true")
        rule.update_attribute(:is_last, true)
        # Rails.logger.warn("APP320 - Updating rule complete.")
      end
    end

  end
end
