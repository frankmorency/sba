class AddCompositeQuestionType < ActiveRecord::Migration
  def change
    qt = QuestionType::CompositeQuestion.new(name: 'composite_question', title: "Composite Question")
    qt.save!
  end
end
