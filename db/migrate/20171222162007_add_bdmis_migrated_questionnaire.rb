class AddBdmisMigratedQuestionnaire < ActiveRecord::Migration
  def change
    eight_a = Questionnaire::EightAMigrated.create! name: 'eight_a_migrated', title: '8(a) Migrated Application', anonymous: false, program: Program.get('eight_a'), certificate_type: CertificateType.get('eight_a'), review_page_display_title: '8(a) Initial Program Self-Certification Summary', link_label: 'BDMIS Archive', human_name: '8(a)'

    eight_a.create_sections! do
      root 'eight_a_root', 1, title: '8(a) Master Application' do
        master_application_section 'eight_a_master', 1, title: '8(a) Master Application', first: true do
          sub_questionnaire 'bdmis_archive', 1, title: 'BDMIS Archive', submit_text: 'Save and continue'
        end
        review_section 'review', 2, title: 'Review', submit_text: 'Submit'
        signature_section 'signature', 3, title: 'Signature', submit_text: 'Accept'
      end
    end

    eight_a.create_rules! do
      section_rule 'eight_a_master', 'bdmis_archive'
      section_rule 'bdmis_archive', 'review'
      section_rule 'review', 'signature'
    end

    Section.where(questionnaire_id: Questionnaire.get('eight_a_migrated').id, name: 'signature').update_all is_last: true

    section = eight_a.root_section.children.find_by(name: 'eight_a_master')
    Section::AdhocQuestionnairesSection.create! name: 'adhoc_questions', title: 'Adhoc Questions', position: 2, submit_text: 'Save and continue', parent: section, questionnaire: eight_a
  end
end