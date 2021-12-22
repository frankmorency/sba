class AddNewYesnoQuestionTypeInstance < ActiveRecord::Migration
  def change
    qt = QuestionType::Boolean.new name: 'yesno_with_comment_required_on_yes_with_attachment_required_on_yes', title: 'Yes, No with Comments Required on Yes and Attachments Required on Yes'
    qt.question_rules.new mandatory: true, value: 'yes', capability: :add_comment, condition: :equal_to
    qt.question_rules.new mandatory: true, value: 'yes', capability: :add_attachment, condition: :equal_to
    qt.save!
  end
end
