class UpdatedEdwosbWosbQuestionInstances < ActiveRecord::Migration
  def change
    
    yesnona_with_comment_required_on_no = QuestionType::YesNoNa.get('yesnona_with_comment_required_on_no')

    q1 = Question.find_by(name: 'oper2_q2')
    q1.update_attribute('question_type_id', yesnona_with_comment_required_on_no.id)
    q1.save!

    qtype_2 = QuestionType.find_by(name: 'yesnona_with_comment_required_on_yes')

    q2 = Question.find_by(name: 'agi_3_year_exceeds_but_uncommon')
    q2.update_attribute('question_type_id', qtype_2.id)
    q2.save!

    q3 = Question.find_by(name: 'woman_asset_transfer_excusable')
    q3.update_attribute('question_type_id', qtype_2.id)
    q3.save!
  end
end
