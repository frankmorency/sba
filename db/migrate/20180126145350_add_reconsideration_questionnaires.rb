class AddReconsiderationQuestionnaires < ActiveRecord::Migration
  def change
    attachment_q = Questionnaire::SubQuestionnaire.create! name: 'reconsideration_attachment',
                                                           title: 'Reconsideration Questionnaire',
                                                           anonymous: false,
                                                           program: Program.get('eight_a'),
                                                           certificate_type: CertificateType.get('eight_a'),
                                                           review_page_display_title: 'Request reconsideration'
    attachment_q.create_sections! do
      root 'adhoc_attachment_root', 1, title: 'Reconsideration Questionnaire' do
        question_section 'reconsideration_attachment_questions', 1, title: 'Request for reconsideration', first: true, submit_text: 'Save and continue' do
          null_with_attachment_required 'reconsideration_attachment_question', 1, title: "<h3 class='sba-c-question__primary-text'>Within 45 days of your decline letter, please attach and submit all items listed in your decline letter under “Steps for Reconsideration,” plus any other information that shows your firm’s eligibility for the 8(a) program.</h3>"
        end
        review_section 'review', 2, title: 'Review'
      end
    end
    attachment_q.create_rules! do
      section_rule 'reconsideration_attachment_questions', 'review'
    end

    Section.where(questionnaire_id: %w( reconsideration_attachment ).map {|q| Questionnaire.get(q).id }, name: 'review').update_all is_last: true
  end
end