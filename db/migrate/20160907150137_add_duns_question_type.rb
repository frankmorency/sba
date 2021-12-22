class AddDunsQuestionType < ActiveRecord::Migration
  def change
    qt = QuestionType::Duns.new(name: 'duns', title: "I need a duns number")
    qt.save!
  end
end
