class AddCheckboxQuestionType < ActiveRecord::Migration
  def change
    qt1 = QuestionType::Checkbox.new name: 'checkbox', title: 'Checkbox'
    qt1.save!
  end
end
