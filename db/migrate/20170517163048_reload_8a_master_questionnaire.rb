class Reload8aMasterQuestionnaire < ActiveRecord::Migration
  def change

    
    Questionnaire::EightAInitial.destroy_all
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
          sub_questionnaire 'eight_a_potential_for_success', 5, title: 'Character', submit_text: 'Save and continue'
          sub_questionnaire 'eight_a_control', 6, title: 'Control', submit_text: 'Save and continue'
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
      section_rule 'eight_a_character', 'eight_a_potential_for_success'
      section_rule 'eight_a_potential_for_success', 'eight_a_control'
      section_rule 'eight_a_control', 'review'
      section_rule 'review', 'signature'
    end

    Section.where(questionnaire_id: Questionnaire.get('eight_a_initial').id, name: 'signature').update_all is_last: true
  end
end
