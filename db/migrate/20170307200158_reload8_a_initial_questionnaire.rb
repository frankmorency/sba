class Reload8AInitialQuestionnaire < ActiveRecord::Migration
  def change
    
    Section.connection.schema_cache.clear!
    Section.reset_column_information
    Section.direct_descendants.each { |klass| klass.reset_column_information }
    Questionnaire::EightAInitial.destroy_all

    ["wosb_v_one", "edwosb_v_one", "mpp", "eight_a", "wosb", "edwosb"].each do |name|
      Section.where(questionnaire_id: Questionnaire.get(name).id, name: 'signature').update_all is_last: true
    end

    ["eight_a_character", "eight_a_control", "eight_a_eligibility", "eight_a_company"].each do |name|
      Section.where(questionnaire_id: Questionnaire.get(name).id, name: 'review').update_all is_last: true
    end

    eight_a = Questionnaire::EightAInitial.create! name: 'eight_a_initial', title: '8(a) Initial Application', anonymous: false, program: Program.get('eight_a'), certificate_type: CertificateType.get('eight_a'), review_page_display_title: '8(a) Initial Program Self-Certification Summary', link_label: '8(a) Initial Program', human_name: '8(a)'

    eight_a.create_sections! do
      root 'eight_a_root', 1, title: '8(a) Master Application' do
        master_application_section 'eight_a_master', 1, title: '8(a) Master Application', first: true do
          sub_questionnaire 'eight_a_eligibility', 1, title: 'Basic Eligibility', submit_text: 'Save and continue', status: Section::NOT_STARTED, prescreening: true
          sub_questionnaire 'eight_a_character', 2, title: 'Character', submit_text: 'Save and continue', status: Section::NOT_STARTED
          sub_questionnaire 'eight_a_control', 3, title: 'Control', submit_text: 'Save and continue', status: Section::NOT_STARTED
          sub_questionnaire 'eight_a_company', 4, title: 'Company Info', submit_text: 'Save and continue', status: Section::NOT_STARTED
        end
        review_section 'review', 2, title: 'Review', submit_text: 'Submit'
        signature_section 'signature', 3, title: 'Signature', submit_text: 'Accept'
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

    Section.where(questionnaire_id: Questionnaire.get('eight_a_initial').id, name: 'signature').update_all is_last: true
  end
end
