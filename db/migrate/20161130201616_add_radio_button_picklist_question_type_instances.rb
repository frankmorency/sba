class AddRadioButtonPicklistQuestionTypeInstances < ActiveRecord::Migration
  def change
    qt1 = QuestionType::Picklist.new name: 'picklist_with_radio_buttons', title: 'Picklist with Radio Buttons'
    qt1.save!

    qt2 = QuestionType::Picklist.new name: 'picklist_with_radio_buttons_with_comment_required_on_last_radio_button', title: 'Picklist with Radio Buttons Comments Required on last Radio Button'
    qt2.question_rules.new mandatory: true, value: '', capability: :add_comment, condition: :equal_to
    qt2.save!

    qt3 = QuestionType::Picklist.new name: 'picklist_with_radio_buttons_with_comment_optional_on_last_radio_button', title: 'Picklist with Radio Buttons Comments Optional on last Radio Button'
    qt3.question_rules.new mandatory: false, value: '', capability: :add_comment, condition: :equal_to
    qt3.save!
  end
end
