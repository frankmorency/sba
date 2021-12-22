class AddAttachmentQuestionTypeForUs1231 < ActiveRecord::Migration
  def change
    
    null_with_attachment_required = QuestionType::Null.new name: 'null_with_attachment_required', title: 'Null with Attachment Required'
    null_with_attachment_required.question_rules.new mandatory: true, capability: :add_attachment, condition: :always
    null_with_attachment_required.save!
  end
end
