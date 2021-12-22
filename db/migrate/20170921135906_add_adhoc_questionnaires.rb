class AddAdhocQuestionnaires < ActiveRecord::Migration
  def change
    
    text_q = Questionnaire::SubQuestionnaire.create! name: 'adhoc_text', title: 'Ad Hoc Text Questionnaire', anonymous: false, program: Program.get('eight_a'), certificate_type: CertificateType.get('eight_a'), review_page_display_title: 'Ad Hoc Questionnaire'
    attachment_q = Questionnaire::SubQuestionnaire.create! name: 'adhoc_attachment', title: 'Ad Hoc Text Questionnaire', anonymous: false, program: Program.get('eight_a'), certificate_type: CertificateType.get('eight_a'), review_page_display_title: 'Ad Hoc Questionnaire'
    text_and_attachment_q = Questionnaire::SubQuestionnaire.create! name: 'adhoc_text_and_attachment', title: 'Ad Hoc Text Questionnaire', anonymous: false, program: Program.get('eight_a'), certificate_type: CertificateType.get('eight_a'), review_page_display_title: 'Ad Hoc Questionnaire'

    text_q.create_sections! do
      root 'adhoc_text_root', 1, title: 'Ad Hoc Questionnaire' do
        question_section 'adhoc_text_questions', 1, title: 'Ad Hoc Questions', first: true, submit_text: 'Save and continue' do
          text_field_multiline 'adhoc_text_question', 1, title: 'To be provided from SBA Analyst'
        end
        signature_section 'signature', 2, title: 'Signature'
      end
    end

    attachment_q.create_sections! do
      root 'adhoc_attachment_root', 1, title: 'Ad Hoc Questionnaire' do
        question_section 'adhoc_attachment_questions', 1, title: 'Ad Hoc Questions', first: true, submit_text: 'Save and continue' do
          null_with_attachment_required 'adhoc_attachment_question', 1, title: 'To be provided from SBA Analyst'
        end
        signature_section 'signature', 2, title: 'Signature'
      end
    end

    text_and_attachment_q.create_sections! do
      root 'adhoc_text_and_attachment_root', 1, title: 'Ad Hoc Questionnaire' do
        question_section 'adhoc_text_and_attachment_questions', 1, title: 'Ad Hoc Questions', first: true, submit_text: 'Save and continue' do
          text_field_multiline 'adhoc_text_question', 1, title: 'To be provided from SBA Analyst'
          null_with_attachment_required 'adhoc_text_and_attachment_question', 2, title: 'To be provided from SBA Analyst'
        end
        signature_section 'signature', 2, title: 'Signature'
      end
    end

    text_q.create_rules! do
      section_rule 'adhoc_text_questions', 'signature'
    end

    attachment_q.create_rules! do
      section_rule 'adhoc_attachment_questions', 'signature'
    end

    text_and_attachment_q.create_rules! do
      section_rule 'adhoc_text_and_attachment_questions', 'signature'
    end

    Section.where(questionnaire_id: %w(adhoc_text adhoc_attachment adhoc_text_and_attachment).map {|q| Questionnaire.get(q).id }, name: 'signature').update_all is_last: true
  end
end
