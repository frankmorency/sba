class UpdateOtherBasisOfDisadvantageQuestion < ActiveRecord::Migration
  def change
        q =  Question.find_by(name: "eight_a_other_basis_of_disadvantage")
    if q.question_type.name == "picklist_with_comment_required"
      q.question_type = QuestionType.find_by(name: "picklist" )
      q.save!
    end
  end
end
