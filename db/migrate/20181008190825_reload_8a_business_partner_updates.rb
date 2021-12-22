class Reload8aBusinessPartnerUpdates < ActiveRecord::Migration
  def change
    Questionnaire.get('eight_a_business_partner').update_attribute :name, 'eight_a_business_partner_v_two'

    business_partner = Questionnaire::SubQuestionnaire.create! name: 'eight_a_business_partner', title: '8(a) Business Partner', anonymous: false, program: Program.get('eight_a'), review_page_display_title: '8(a) Business Partner'

    business_partner.create_sections! do
      root 'eight_a_business_partner', 1, title: '8(a) Business Partner' do
        question_section 'eight_a_business_partner_general_information', 1, title: 'General Information', submit_text: 'Save and continue' do
          question_section 'eight_a_business_partner_gender', 1, title: 'Gender', first: true do
            picklist 'gender', 1, title: 'Legal Gender', possible_values: ['Female', 'Male']
          end
          question_section 'eight_a_business_partner_marital_status', 2, title: 'Marital Status' do
            picklist_with_radio_buttons_with_attachment_required_on_last_radio_button 'eight_a_marital_status', 1, title: 'Marital Status', possible_values: ['Unmarried', 'Married', 'Legally Separated']
          end
          question_section 'eight_a_business_partner_social_security_number', 3, title: 'Social Security Number' do
            text_field_single_line 'social_security_number', 1, title: 'Social Security Number'
          end
          question_section 'eight_a_business_partner_contact_information', 4, title: 'Contact Information' do
            text_field_single_line 'phone_number', 1, title: 'Best contact phone number'
          end
          question_section 'eight_a_business_partner_current_home_address', 5, title: 'Current Home Address' do
            full_address 'current_home_address', 1, title: 'Provide your current home address'
            date 'eight_a_current_home_dates_of_residency', 2, title: 'Dates of Residency'
          end
          question_section 'eight_a_business_partner_length_of_residency', 6, title: 'Length of residency' do
            yesno 'has_been_ten_years', 1, title: 'Have you lived at your present address more than 10 years?'
          end
          question_section 'eight_a_business_partner_previous_home_address', 7, title: 'Previous Home Address' do
            full_address 'previous_home_address', 2, title: 'Provide your most recent previous home address'
            date_range 'eight_a_previous_home_dates_of_residency', 3, title: 'Dates of Residency'
          end
          question_section 'eight_a_business_partner_date_place_of_birth', 8, title: 'Date and Place of Birth' do
            date 'date_of_birth', 1, title: 'Date of Birth'
            text_field_single_line 'place_of_birth', 2, title: 'Place of Birth'
            picklist 'country_of_birth', 3, title: 'Country of Birth', possible_values: Country.pluck(:name).unshift('United States').uniq
          end
          question_section 'eight_a_business_partner_us_citizenship', 9, title: 'U.S. Citizenship' do
            question 'us_citizen', 1, title: 'Are you a U.S. Citizen?'
          end
          question_section 'eight_a_business_partner_resident_alien', 10, title: 'Resident Alien' do
            yesno_with_comment_required 'resident_alien', 1, title: 'Are you a Lawful Permanent Resident Alien?'
          end
        end
        question_section 'eight_a_business_partner_ownership_control', 3, title: 'Ownership and Control', submit_text: 'Save and continue' do
          question_section 'eight_a_business_partner_applicant_firm_ownership', 1, title: 'Applicant Firm Ownership' do
            percentage 'percentage', 1, title: 'What percentage of the Applicant Firm do you own?'
            text_field_multiline 'all_positions_with_firm', 2, title: 'List all positions you hold in the Applicant Firm.'
          end
          question_section 'eight_a_business_partner_bank_account_access', 2, title: 'Bank Account Access' do
            yesno_with_comment_optional_on_yes 'eight_a_bank_account_access', 1, title: "Are you authorized to access or make withdrawals from the Applicant Firm’s bank account?"
          end
          question_section 'eight_a_business_partner_prior_ownership', 3, title: 'Prior Ownership' do
            yesno_with_comment_optional_on_yes 'former_employer', 1, title: "Are you the former employer of the Individual Claiming Disadvantage?"
            yesno_with_attachment_required_on_yes 'former_majority_owner', 2, title: 'Are you the former majority owner (51% or more) of the Applicant Firm?'
          end
          question_section 'eight_a_business_partner_business_affiliations', 4, title: 'Business Affiliations' do
            yesno_with_attachment_required_on_yes 'eight_a_business_affiliations', 1, title: 'Do you own or work for any other firm that has a relationship with the Applicant Firm?'
            yesno_with_comment_required_on_yes 'eight_a_family_contractual_affiliation', 2, title: 'Do any of your immediate family members own a firm with a contractual relationship with the Applicant Firm?'
          end
        end
        question_section 'eight_a_business_partner_8a_eligibility', 4, title: '8(a) Program Eligibility', submit_text: 'Save and continue' do
          question_section 'eight_a_business_partner_prior_involvement', 1, title: 'Prior 8a Involvement' do
            yesno_with_attachment_required_on_yes 'eight_a_eligibility_q0', 1, title: 'Have you – or any firm you owned – ever applied for 8(a) Certification or participated in the 8(a) Program?'
            yesno 'eight_a_eligibility_q1', 2, title: 'Have you already used your one-time-only 8(a) eligibility to qualify a business for the 8(a) Program?'
            yesno_with_attachment_required_on_yes 'eight_a_eligibility_q2', 3, title: 'Have any of your immediate family members ever owned a firm that was admitted to the 8(a) Program?'
          end
          question_section 'eight_a_business_partner_federal_employment', 2, title: 'Federal Employment' do
            yesno_with_attachment_required_on_yes 'eight_a_federal_employment_q0', 1, title: 'Are you a Federal Government employee holding a position of GS-13 or above?'
            yesno_with_attachment_required_on_yes 'eight_a_household_federal_employment_q0', 2, title: "Is any member of your household a Federal Government employee holding a position of GS-13 or above?"
          end
        end
        question_section 'eight_a_business_partner_character', 5, title: 'Character', submit_text: 'Save and continue' do
          question_section 'eight_a_business_partner_financial', 1, title: 'Financial' do
            yesno_with_attachment_required_on_yes 'eight_a_financial_q0', 1, title: 'Have you filed for personal bankruptcy within the past 7 years?'
            yesno_with_attachment_required_on_yes 'eight_a_financial_q1', 2, title: 'Have you previously obtained an SBA loan?'
            yesno_with_attachment_required_on_yes 'eight_a_financial_q2', 3, title: 'Are you a party to a pending civil lawsuit?'
            yesno_with_attachment_required_on_yes 'eight_a_financial_q3', 4, title: 'Are you delinquent in paying or filing any of the following:<ul><li>Federal or Federally guaranteed obligations (including Federal student loans)</li><li>Business taxes or liens</li><li>Personal Federal, State, or local tax returns</li></ul>'
          end
          question_section 'eight_a_business_partner_criminal_history', 2, title: 'Criminal History' do
            yesno_with_comment_required_on_yes 'eight_a_criminal_history_q0', 1, title: 'Have you ever gone by any other names?'
            yesno 'criminal_history_q1', 2, title: 'Are you presently subject to an indictment, criminal information, arraignment, or other means by which formal criminal charges are brought in any jurisdiction? '
            yesno 'criminal_history_q2', 3, title: 'Have you been arrested in the past six months for any criminal offense?'
            yesno 'criminal_history_q3', 4, title: 'For any criminal offense – other than a minor vehicle violation – have you ever: <ul><li>Been convicted</li><li>Plead guilty</li><li>Plead nolo contendere</li><li>Been placed on pretrial diversion</li><li>Been placed on any form of parole or probation (including probation before judgment)</li></ul>'
          end
          question_section 'eight_a_business_partner_criminal_history_documentation', 3, title: 'Criminal History Documentation' do
            null_with_attachment_required 'criminal_history_doc_q0', 1, title: 'Upload a narrative for EACH “YES” answer.'
            null_with_attachment_required 'criminal_history_doc_q1', 2, title: 'Upload copies of all relevant court dispositions or documents.'
            null_with_attachment_required 'criminal_history_doc_q2', 3, title: 'Upload a completed Form FD-258 Fingerprint Card.'
          end
        end
        review_section 'review', 7, title: 'Review', submit_text: 'Submit'
        signature_section 'signature', 8, title: 'Signature'
      end
    end

    business_partner.create_rules! do
      section_rule 'eight_a_business_partner_gender', 'eight_a_business_partner_marital_status'
      section_rule 'eight_a_business_partner_marital_status', 'eight_a_business_partner_social_security_number'
      section_rule 'eight_a_business_partner_social_security_number', 'eight_a_business_partner_contact_information'
      section_rule 'eight_a_business_partner_contact_information', 'eight_a_business_partner_current_home_address'
      section_rule 'eight_a_business_partner_current_home_address', 'eight_a_business_partner_length_of_residency'
      section_rule 'eight_a_business_partner_length_of_residency', 'eight_a_business_partner_previous_home_address', {
          klass: 'Answer', identifier: 'has_been_ten_years', value: 'no'
      }
      section_rule 'eight_a_business_partner_length_of_residency', 'eight_a_business_partner_date_place_of_birth', {
          klass: 'Answer', identifier: 'has_been_ten_years', value: 'yes'
      }
      section_rule 'eight_a_business_partner_previous_home_address', 'eight_a_business_partner_date_place_of_birth'
      section_rule 'eight_a_business_partner_date_place_of_birth', 'eight_a_business_partner_us_citizenship'
      section_rule 'eight_a_business_partner_us_citizenship', 'eight_a_business_partner_resident_alien', {
          klass: 'Answer', identifier: 'us_citizen', value: 'no'
      }
      section_rule 'eight_a_business_partner_us_citizenship', 'eight_a_business_partner_applicant_firm_ownership', {
          klass: 'Answer', identifier: 'us_citizen', value: 'yes'
      }
      section_rule 'eight_a_business_partner_resident_alien', 'eight_a_business_partner_applicant_firm_ownership'
      section_rule 'eight_a_business_partner_applicant_firm_ownership', 'eight_a_business_partner_bank_account_access'
      section_rule 'eight_a_business_partner_bank_account_access', 'eight_a_business_partner_prior_ownership'
      section_rule 'eight_a_business_partner_prior_ownership', 'eight_a_business_partner_business_affiliations'
      section_rule 'eight_a_business_partner_business_affiliations', 'eight_a_business_partner_prior_involvement'
      section_rule 'eight_a_business_partner_prior_involvement', 'eight_a_business_partner_federal_employment'
      section_rule 'eight_a_business_partner_federal_employment', 'eight_a_business_partner_financial'
      section_rule 'eight_a_business_partner_financial', 'eight_a_business_partner_criminal_history'

      section_rule 'eight_a_business_partner_criminal_history', 'review',[
          {klass: 'Answer', identifier: 'eight_a_criminal_history_q0', value: 'yes'},
          {klass: 'Answer', identifier: 'criminal_history_q1', value: 'no'},
          {klass: 'Answer', identifier: 'criminal_history_q2', value: 'no'},
          {klass: 'Answer', identifier: 'criminal_history_q3', value: 'no'}
      ]
      section_rule 'eight_a_business_partner_criminal_history', 'review',[
          {klass: 'Answer', identifier: 'eight_a_criminal_history_q0', value: 'no'},
          {klass: 'Answer', identifier: 'criminal_history_q1', value: 'no'},
          {klass: 'Answer', identifier: 'criminal_history_q2', value: 'no'},
          {klass: 'Answer', identifier: 'criminal_history_q3', value: 'no'}
      ]
      section_rule 'eight_a_business_partner_criminal_history', 'eight_a_business_partner_criminal_history_documentation', {
          klass: 'Answer', identifier: 'criminal_history_q1', value: 'yes'
      }
      section_rule 'eight_a_business_partner_criminal_history', 'eight_a_business_partner_criminal_history_documentation', {
          klass: 'Answer', identifier: 'criminal_history_q2', value: 'yes'
      }
      section_rule 'eight_a_business_partner_criminal_history', 'eight_a_business_partner_criminal_history_documentation', {
          klass: 'Answer', identifier: 'criminal_history_q3', value: 'yes'
      }

      section_rule 'eight_a_business_partner_criminal_history_documentation', 'review'
      section_rule 'review', 'signature'
    end

    Section.where(questionnaire_id: Questionnaire.get('eight_a_business_partner').id, name: 'signature').update_all is_last: true

    eight_a = Questionnaire::EightAInitial.get('eight_a_initial')
    section = eight_a.sections.select{|s| s.name == 'eight_a_business_partner'}.first
    section.sub_questionnaire = business_partner
    section.save!
  end
end
