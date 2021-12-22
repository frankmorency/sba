class AddEightAAnnualReviewQuestionnaire < ActiveRecord::Migration
  def change
    eight_a = Questionnaire::EightAAnnualReview.create! name: 'eight_a_annual_review', title: '8(a) Annual Review', anonymous: false, program: Program.get('eight_a'), certificate_type: CertificateType.get('eight_a'), review_page_display_title: '8(a) Annual Review', link_label: '8(a) Annual Review', human_name: '8(a)'

    eight_a.create_sections! do
      root 'eight_a_root', 1, title: '8(a) Annual Review' do
        master_application_section 'eight_a_annual_review', 1, title: '8(a) Annual Review', first: true do
          sub_questionnaire 'eight_a_annual_review_eligibility', 1, title: 'Eligibility', submit_text: 'Save and continue'
          sub_questionnaire 'eight_a_annual_review_ownership', 2, title: 'Ownership', submit_text: 'Save and continue'
          sub_questionnaire 'eight_a_annual_control', 3, title: 'Control', submit_text: 'Save and continue'
          sub_questionnaire 'eight_a_annual_business_development', 4, title: 'Business Development', submit_text: 'Save and continue'
          contributor_section 'disadvantaged_individuals', 4, title: 'Contributors', submit_text: 'Save and continue' do
            contributor_section 'vendor_admin', 1, title: 'Vendor Administrator', description: 'Vendor Administrator on certify.SBA.gov and 8(a) Applicant:', submit_text: 'Start your individual application now' do
              sub_questionnaire 'contributor_va_eight_a_disadvantaged_individual', 2, questionnaire: 'eight_a_disadvantaged_individual_annual_review', title: 'Disadvantaged Individual', submit_text: 'Save and continue'
            end

            contributor_section 'eight_a_disadvantaged_individual', 2,
                                title: 'Disadvantaged Individual',
                                sub_questionnaire: 'eight_a_disadvantaged_individual_annual_review',
                                description: 'Please add another 8(a) Applicant, if applicable.',
                                submit_text: 'Add another Disadvantaged Individual, if applicable'

            contributor_section 'eight_a_spouse', 3,
                                title: '(8a) Applicant Spouse',
                                sub_questionnaire: 'eight_a_spouse_annual_review',
                                description: 'Please add the spouse of any Disadvantaged Individual',
                                submit_text: 'Add a spouse of a Disadvantaged Individual'

            contributor_section 'eight_a_business_partner', 4,
                                title: 'Business Partner',
                                sub_questionnaire: 'eight_a_business_partner_annual_review',
                                description: 'Please add all other individuals directly involved with the business.',
                                submit_text: 'Add other individuals'
          end
        end
        review_section 'review', 2, title: 'Review', submit_text: 'Submit'
        signature_section 'signature', 3, title: 'Signature', submit_text: 'Accept'
      end

      eight_a.create_rules! do
        section_rule 'eight_a_annual_review', 'eight_a_annual_review_eligibility'
        section_rule 'eight_a_annual_review_eligibility', 'eight_a_annual_review_ownership'
        section_rule 'eight_a_annual_review_ownership', 'eight_a_annual_control'
        section_rule 'eight_a_annual_control', 'eight_a_annual_business_development'
        section_rule 'eight_a_annual_business_development', 'disadvantaged_individuals'
        section_rule 'disadvantaged_individuals', 'review'
        section_rule 'review', 'signature'
      end

      Section.where(questionnaire_id: Questionnaire.get('eight_a_annual_review').id, name: 'signature').update_all is_last: true

      section = eight_a.root_section.children.find_by(name: 'eight_a_annual_review')
      Section::AdhocQuestionnairesSection.create! name: 'adhoc_questions', title: 'Adhoc Questions', position: 2, submit_text: 'Save and continue', parent: section, questionnaire: eight_a
      CertificateType.get('eight_a').current_questionnaires.create!(questionnaire: eight_a, kind: 'annual_review')
    end
  end
end