class CreateCheckboxesWithCommentRequiredOnLastSelection < ActiveRecord::Migration
  def change
    new_question = QuestionType::Checkbox.new(name: 'checkboxes_with_comment_required_on_last_selection',
                                              title: 'Checkbox with Comment Required On Last Selection',
                                              config_options: {show_comment: 'last_only'})
    new_question.question_rules.new mandatory: true, value:'Other', capability: :add_comment, condition: :equal_to
    new_question.save!
  end
end