class CreatePotentialForSuccessQuestionnaire < ActiveRecord::Migration
  def change

    
    pos = Questionnaire::SubQuestionnaire.create! name: 'eight_a_potential_for_success', title: '8(a) Applicant enters business\'s Potential for Success information', anonymous: false, program: Program.get('eight_a'), review_page_display_title: '8(a) Applicant enters business\'s Potential for Success information'

    c = QuestionType::DataEntryGrid.new name: 'data_entry_grid_contracts_awarded', title: 'Data Entry Grid Contracts Awarded'
    c.save!

    pos.create_sections! do
      root 'eight_a_potential_for_success', 1, title: 'POS' do

        question_section 'potential_for_success', 0, title: 'Potential for Success' do

          question_section 'eight_a_pos_taxes', 0, title: 'Taxes', first: true do
            null_with_attachment_required 'eight_a_pos_taxes', 1, title: 'Please upload the applicant firm’s Federal tax returns filed in the last three years, including all schedules and attachments.', possible_values: ['Male', 'Female', 'Other']
          end
          question_section 'eight_a_pos_revenue', 1, title: 'Revenue' do
            yesno_with_comment_required_on_no 'eight_a_pos_revenue_a', 1, title: 'Is NAICS code for which the applicant firm is applying to the 8(a) Business Development Program the same as the applicant firm’s primary NAICS code listed in SAM.gov?'
            yesno_with_attachment_required_on_no 'eight_a_pos_revenue_b', 2, title:'Has the applicant firm earned revenues in its primary NAICS code for at least two years?'
            percentage 'eight_a_pos_revenue_c', 2, title: 'What percentage of revenues were earned in the applicant firm’s primary NAICS code during the most recently completed fiscal year?'
            data_entry_grid_contracts_awarded 'eight_a_pos_revenue_d', 2, title: 'Please list current and past Federal and non-Federal awarded contracts within the last 12 months.', strategy: "ContractsAwarded"
            null_with_attachment_required 'eight_a_pos_revenue_e', 2, title: 'Please upload an interim or year-end balance sheet and profit and loss statement.'
          end
          question_section 'eight_a_pos_pos', 2, title: 'Potential for Success' do
            yesno_with_attachment_required_on_yes 'eight_a_pos_other', 1, title: 'Do you have any loan agreements that are not commercial bank loans?'
            yesno_with_attachment_required_on_yes 'eight_a_pos_pos_a', 2, title: 'Do you have any special licenses under which the applicant firm operates?'
            yesnona_with_attachment_required_on_yes 'eight_a_pos_pos_b', 3, title: 'Do you have statements of bonding ability from the applicant firm’s surety?' 
          end
        end

        review_section 'review', 7, title: 'Review', submit_text: 'Accept'
      end
    end

    pos.create_rules! do
      section_rule 'eight_a_pos_taxes', 'eight_a_pos_revenue'
      section_rule 'eight_a_pos_revenue', 'eight_a_pos_pos'
      section_rule 'eight_a_pos_pos', 'review'
    end
    
    # Setting up Document Types
    q = Question.find_by_name('eight_a_pos_taxes')
    dt = DocumentType.create!(name: "Firm income tax returns")
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: dt.id

    q = Question.find_by_name('eight_a_pos_revenue_b')
    DocumentType.find_by_name("Firm income tax returns")
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: dt.id
    
    q = Question.find_by_name('eight_a_pos_revenue_e')
    dt = DocumentType.create!(name: "Balance Sheet")
    dt1 = DocumentType.create!(name: "Profit and Loss Statement")
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: dt.id
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: dt1.id
    
    q = Question.find_by_name('eight_a_pos_other')
    dt = DocumentType.create!(name: "Business loans and lines of credit")
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: dt.id

    q = Question.find_by_name('eight_a_pos_pos_a')
    dt = DocumentType.create!(name: "License")
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: dt.id
    
    q = Question.find_by_name('eight_a_pos_pos_b')
    dt = DocumentType.create!(name: "Statement of bonding ability")
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: dt.id

    eight_a = Questionnaire::EightAInitial.create! name: 'eight_a_initial', title: '8(a) Initial Application', anonymous: false, program: Program.get('eight_a'), certificate_type: CertificateType.get('eight_a'), review_page_display_title: '8(a) Initial Program Self-Certification Summary', link_label: '8(a) Initial Program', human_name: '8(a)'

    eight_a.create_sections! do
      root 'eight_a_root', 1, title: '8(a) Master Application' do
        master_application_section 'eight_a_master', 1, title: '8(a) Master Application', first: true do
          sub_questionnaire 'eight_a_eligibility', 1, title: 'Basic Eligibility', submit_text: 'Save and continue', prescreening: true
          sub_questionnaire 'eight_a_business_ownership', 2, title: 'Business Ownership', submit_text: 'Save and continue'
          contributor_section 'disadvantaged_individuals', 3, title: 'Contributors', submit_text: 'Save and continue' do
            contributor_section 'vendor_admin', 1,
                                title: 'Vendor Administrator',
                                description: 'Vendor Administrator on certify.SBA.gov and 8(a) Applicant:',
                                submit_text: 'Start your individual application now' do
              sub_questionnaire 'contributor_va_eight_a_disadvantaged_individual', 2, questionnaire: 'eight_a_disadvantaged_individual', title: 'Disadvantaged Individual', submit_text: 'Save and continue'
            end
            
            contributor_section 'eight_a_disadvantaged_individual', 2,
                                title: 'Disadvantaged Individual',
                                sub_questionnaire: 'eight_a_disadvantaged_individual',
                                description: 'Please add another 8(a) Applicant, if applicable.',
                                submit_text: 'Add another Disadvantaged Individual, if applicable'

            contributor_section 'eight_a_spouse', 3,
                                title: '(8a) Applicant Spouse',
                                sub_questionnaire: 'eight_a_spouse',
                                description: 'Please add the spouse of any Disadvantaged Individual',
                                submit_text: 'Add a spouse of a Disadvantaged Individual'
            
            contributor_section 'eight_a_business_partner', 4,
                                title: 'Business ',
                                sub_questionnaire: 'eight_a_business_partner',
                                description: 'Please add all other individuals directly involved with the business.',
                                submit_text: 'Add other individuals'
          end
          sub_questionnaire 'eight_a_character', 4, title: 'Character', submit_text: 'Save and continue'
          sub_questionnaire 'eight_a_control', 5, title: 'Control', submit_text: 'Save and continue'
          sub_questionnaire 'eight_a_company', 6, title: 'Company Info', submit_text: 'Save and continue'
        end
        review_section 'review', 2, title: 'Review', submit_text: 'Submit'
        signature_section 'signature', 3, title: 'Signature', submit_text: 'Accept'
      end
    end

    eight_a.create_rules! do
      section_rule 'eight_a_master', 'eight_a_eligibility'
      section_rule 'eight_a_eligibility', 'eight_a_business_ownership'
      section_rule 'eight_a_business_ownership', 'disadvantaged_individuals'
      section_rule 'disadvantaged_individuals', 'eight_a_character'
      section_rule 'eight_a_character', 'eight_a_control'
      section_rule 'eight_a_control', 'eight_a_company'
      section_rule 'eight_a_company', 'review'
      section_rule 'review', 'signature'
    end

    SectionRule.where(to_section_id: Section.where(name: 'review').pluck(:id)).each do |rule|
      if rule.from_section.name == 'form413' || rule.from_section.name =~ /^personal_privacy_/
        # Rails.logger.warn("APP320 - Updating rule (#{rule.debug}) to set is_last to true")
        rule.update_attribute(:is_last, true)
        # Rails.logger.warn("APP320 - Updating rule complete.")
      end
    end
    Section.where(questionnaire_id: Questionnaire.get('eight_a_initial').id, name: 'signature').update_all is_last: true

  end
end
