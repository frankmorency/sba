class CreateCheckboxesWithAttachmentOptionalWithCommentOptionalOnLastSelection < ActiveRecord::Migration
  def change
    new_question = QuestionType::Checkbox.new(name: 'checkboxes_with_optional_attachment_and_required_comment_on_all_except_last_selection',
                                              title: 'Checkbox with Optional Attachment And Required Comment On All Except Last Selection')
    new_question.question_rules.new mandatory: false, capability: :add_attachment, condition: :always
    new_question.question_rules.new mandatory: true, value:'', capability: :add_comment, condition: :not_equal_to
    new_question.save!
  end
end