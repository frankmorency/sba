class FixAdhocQuestionnaire < ActiveRecord::Migration
  def change
    
    add_column :sba_applications, :unanswered_adhoc_reviews, :integer, default: 0

    adhoc_dt = DocumentType.create! name: '8(a) Additional Info'


    text_and_attachment = QuestionType::TextField.new(name: 'text_field_multiline_with_attachment',
                                                      title: 'Text Field Multiline With Attachment',
                                                      config_options: {num_lines: 'multi'})
    text_and_attachment.question_rules.new mandatory: true, capability: :add_attachment, condition: :always
    text_and_attachment.save!

    Questionnaire.find_by(name: 'adhoc_text_and_attachment').destroy

    text_and_attachment_q = Questionnaire::SubQuestionnaire.create! name: 'adhoc_text_and_attachment', title: 'Ad Hoc Text Questionnaire', anonymous: false, program: Program.get('eight_a'), certificate_type: CertificateType.get('eight_a'), review_page_display_title: 'Ad Hoc Questionnaire'

    text_and_attachment_q.create_sections! do
      root 'adhoc_text_and_attachment_root', 1, title: 'Ad Hoc Questionnaire' do
        question_section 'adhoc_text_and_attachment_questions', 1, title: 'Additional Information Request', first: true, submit_text: 'Save and continue' do
          text_field_multiline_with_attachment 'adhoc_text_and_attachment', 1, title: 'To be provided from SBA Analyst', document_types: '8(a) Additional Info'
        end
        review_section 'review', 2, title: 'Review', submit_text: "Submit"
      end
    end

    text_and_attachment_q.create_rules! do
      section_rule 'adhoc_text_and_attachment_questions', 'review'
    end

    Section::QuestionSection.where(name: %w(adhoc_attachment_questions adhoc_text_questions)).each do |section|
      section.update_attributes title: 'Additional Information Request'
    end

    q = Questionnaire.find_by(name: 'adhoc_attachment')
    if signature_section = q.sections.find_by(name: 'signature')
      signature_section.update_attributes type: "Section::ReviewSection", title: "Review", submit_text: "Submit", name: "review", is_last: true
    end
    if answer_section = q.first_section
      question = answer_section.questions.first
      question.document_type_questions << DocumentTypeQuestion.new(document_type_id: adhoc_dt.id)
      question.save!
    end
    q.sba_applications.destroy_all

    q = Questionnaire.find_by(name: 'adhoc_text')
    if signature_section = q.sections.find_by(name: 'signature')
      signature_section.update_attributes type: "Section::ReviewSection", title: "Review", submit_text: "Submit", name: "review", is_last: true
    end
    q.sba_applications.destroy_all
  end
end
