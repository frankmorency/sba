class CreateEightAAnnualReviewControlQuestionnaire < ActiveRecord::Migration
  def change
    Questionnaire.transaction do
      eight_a_control_annual = Questionnaire::SubQuestionnaire.create! name: 'eight_a_annual_control', title: '8(a) Basic Ownership', anonymous: false, program: Program.get('eight_a'), review_page_display_title: '8(a) Ownership Summary'
      eight_a_control_annual.create_sections! do
        root 'eight_a_control_annual_root', 1, title: 'Control' do
          question_section 'eight_a_annual_review_control_header', 0, title: 'Control' do
            question_section 'outside_assistance', 0, title: 'Outside assistance', submit_text: 'Save and continue', first: true do
              yesno_with_attachment_required_on_yes 'outside_assistance_q1', 0, title: 'First tell us about the past 6 months:<br/>Did your firm hire outside assistance to help you get federal contracts?'
              yesno_with_attachment_required_on_yes 'outside_assistance_q2', 1, title: 'Next tell us about first 6 months of the program year:<br/>Did your firm hire outside assistance to help you get federal contracts?'
            end
            question_section 'compensation', 1, title: 'Compensation', submit_text: 'Save and continue' do
              picklist_with_radio_buttons_with_attachment_required_on_last_radio_button 'compensation_q1', 1, title: 'Are you the highest paid employee at your firm?', possible_values: ['My firm is entity owned, so this question doesn\'t apply to me.', 'Yes', 'No']
            end
            question_section 'affiliates', 2, title: 'Affiliates', submit_text: 'Save and continue' do
              question_section 'affiliates_s1', 0, title: 'Affiliates' do
                yesno  'affiliates_q1', 0, title: 'Does your firm have known affiliates?'
              end
              question_section 'affiliates_s2', 1, title: 'Changes to Affiliates' do
                yesno_with_attachment_required_on_yes 'changes_to_affiliates_q1', 0, title: 'In the past fiscal year, has your firm added or removed affiliates?'
              end
            end
          end
          review_section 'review', 1, title: 'Review', submit_text: 'Submit'
        end
        Section.where(questionnaire_id: eight_a_control_annual.id, name: 'review').update_all is_last: true
      end

      eight_a_control_annual.create_rules! do
        section_rule 'outside_assistance', 'compensation'
        section_rule 'compensation', 'affiliates_s1'
        section_rule 'affiliates_s1', 'affiliates_s2', {
          klass: 'Answer', identifier: 'affiliates_q1', value: 'yes'
        }
        section_rule 'affiliates_s1', 'review', {
            klass: 'Answer', identifier: 'affiliates_q1', value: 'no'
        }
        section_rule 'affiliates_s2', 'review'

      end

      #  Creating the new document types
      dt = DocumentType.create! name: "SBA Form 1790"
      q = Question.find_by(name: 'outside_assistance_q1')
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: dt.id
      q = Question.find_by(name: 'outside_assistance_q2')
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: dt.id

      dt = DocumentType.create! name: "Compensation Explanation"
      q = Question.find_by(name: 'compensation_q1')
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: dt.id    \

      dt = DocumentType.create! name: "Current affiliates"
      q = Question.find_by(name: 'changes_to_affiliates_q1')
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: dt.id
    end

  end
end
