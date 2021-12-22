class AddRepeatingQuestionType < ActiveRecord::Migration
  def change
    
    qt = QuestionType::RepeatingQuestion.new(name: 'repeating_question', title: "Repeating Question")
    qt.save!
  end
end
