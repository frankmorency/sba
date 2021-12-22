class Load8aInitialQuestionnaire < ActiveRecord::Migration
  def change
    
    Questionnaire.transaction do
      eight_a = Questionnaire::EightAInitial.create! name: 'eight_a_initial', title: '8(a) Initial Application', anonymous: false, program: Program.get('eight_a'), certificate_type: CertificateType.get('eight_a'), review_page_display_title: '8(a) Initial Program Self-Certification Summary', link_label: '8(a) Initial Program', human_name: '8(a)'

      eight_a_eligibility = Questionnaire::SubQuestionnaire.create! name: 'eight_a_eligibility', title: '8(a) Basic Eligibility', anonymous: false, program: Program.get('eight_a'), review_page_display_title: '8(A) Eligibility Summary'
      eight_a_company = Questionnaire::SubQuestionnaire.create! name: 'eight_a_company', title: '8(a) Company Information', anonymous: false, program: Program.get('eight_a'), review_page_display_title: '8(A) Company Information Summary'

      eight_a_eligibility.create_sections! do
        root 'eight_a_eligibility', 1, title: '8(a) Application' do
          question_section 'eight_a_basic_eligibility', 1, title: 'Basic Eligibility', submit_text: 'Save and continue', first: true  do
            yesno 'for_profit_or_ag_coop', 0
            yesno 'mentor_for_profit', 1
          end
          question_section 'eight_a_eligibility_too', 2, title: 'More Eligibility', submit_text: 'Save and continue' do
            yesno 'prior_sba_mpp_determination', 2
            yesno 'mentor_over_40_percent_protege', 3
          end
          review_section 'review', 3, title: 'Review', submit_text: 'Submit'
        end
      end

      eight_a_company.create_sections! do
        root 'eight_a_company', 1, title: '8(a) Application' do
          question_section 'eight_a_company_stuff', 1, title: 'Company Stuff', submit_text: 'Save and continue', first: true  do
            yesno 'prior_naics_code_work', 0
            yesno 'small_for_mpp_naics_code', 1
          end
          question_section 'eight_a_company_stuff_too', 2, title: 'More Co Stuff', submit_text: 'Save and continue' do
            yesno 'have_redetermination_letter', 1
          end
          review_section 'review', 3, title: 'Review', submit_text: 'Submit'
        end
      end

      eight_a_eligibility.create_rules! do
        section_rule 'eight_a_basic_eligibility', 'eight_a_eligibility_too'
        section_rule 'eight_a_eligibility_too', 'review'
      end

      eight_a_company.create_rules! do
        section_rule 'eight_a_company_stuff', 'eight_a_company_stuff_too'
        section_rule 'eight_a_company_stuff_too', 'review'
      end

      eight_a.create_sections! do
        root 'eight_a_root', 1, title: '8(a) Master Application' do
          master_application_section 'eight_a_master', 1, title: '8(a) Master Application', first: true do
            sub_questionnaire 'eight_a_eligibility', 1, title: 'Basic Eligibility', submit_text: 'Save and continue'
            sub_questionnaire 'eight_a_character', 2, title: 'Character', submit_text: 'Save and continue'
            sub_questionnaire 'eight_a_control', 3, title: 'Control', submit_text: 'Save and continue'
            sub_questionnaire 'eight_a_company', 4, title: 'Company Info', submit_text: 'Save and continue'
            review_section 'review', 5, title: 'Review', submit_text: 'Submit'
            signature_section 'signature', 6, title: 'Signature', submit_text: 'Accept'
          end
        end
      end

      eight_a.create_rules! do
        section_rule 'eight_a_master', 'eight_a_eligibility'
        section_rule 'eight_a_eligibility', 'eight_a_character'
        section_rule 'eight_a_character', 'eight_a_control'
        section_rule 'eight_a_control', 'eight_a_company'
        section_rule 'eight_a_company', 'review'
        section_rule 'review', 'signature'
      end
    end
  end
end