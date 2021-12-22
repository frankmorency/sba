class CreateNullInfoRequestQuestionnaire < ActiveRecord::Migration
  def change
    if %w(dev development qa test build docker).include? Rails.env
      blank = Questionnaire::AdverseActionBlank.create! name: 'adverse_action_blank', title: 'Adverse Action Blank',
                                                       anonymous: false, program: Program.get('eight_a'),
                                                       certificate_type: CertificateType.get('eight_a'),
                                                       review_page_display_title: '8(a) Information Request',
                                                       link_label: '8(a) Info Request', human_name: '8(a)'

      blank.create_sections! do
        root 'eight_a_root', 1, title: 'Adverse Action Blank' do
          master_application_section 'eight_a_master', 1, title: '8(a) Master Application', first: true do
            adhoc_questionnaires_section 'adverse_action_details', title: 'Adverse Action Details', position: 1, submit_text: 'Save and continue'
          end
        end
      end

      blank.sections.find_by(name: 'adverse_action_details').update_attribute :is_last, true
    end
  end
end
