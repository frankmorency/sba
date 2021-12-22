class LoadAdhocSimpleQuestionnaires < ActiveRecord::Migration
  def change
    eight_a = Questionnaire::EightAInfoRequest.create! name: 'eight_a_info_request', title: '8(a) Information Request',
                                                       anonymous: false, program: Program.get('eight_a'),
                                                       certificate_type: CertificateType.get('eight_a'),
                                                       review_page_display_title: '8(a) Information Request',
                                                       link_label: '8(a) Info Request', human_name: '8(a)'

    eight_a.create_sections! do
      root 'eight_a_root', 1, title: '8(a) Master Application' do
        master_application_section 'eight_a_master', 1, title: '8(a) Master Application', first: true do
          adhoc_questionnaires_section 'adhoc_questions', title: 'Adhoc Questions', position: 1, submit_text: 'Save and continue'
        end
        review_section 'review', 2, title: 'Review', submit_text: 'Submit'
        signature_section 'signature', 3, title: 'Signature', submit_text: 'Accept'
      end
    end

    eight_a.create_rules! do
      section_rule 'eight_a_master', 'review'
      section_rule 'review', 'signature'
    end

    eight_a.sections.find_by(name: 'signature').update_attribute :is_last, true
  end
end
