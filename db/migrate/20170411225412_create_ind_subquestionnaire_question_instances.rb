class CreateIndSubquestionnaireQuestionInstances < ActiveRecord::Migration
  def change

    picklist_with_comment_required = QuestionType::Picklist.new name: 'picklist_with_comment_required', title: 'Picklist with Comment Always Required'
    picklist_with_comment_required.question_rules.new mandatory: true, capability: :add_comment, condition: :always
    picklist_with_comment_required.save!

    picklist_with_radio_buttons_with_attachment_required_on_last_radio_button = QuestionType::Picklist.new name: 'picklist_with_radio_buttons_with_attachment_required_on_last_radio_button', title: 'Picklist with Radio Buttons, Attachment Required on last Radio Button'
    picklist_with_radio_buttons_with_attachment_required_on_last_radio_button.question_rules.new mandatory: true, value: '', capability: :add_attachment, condition: :equal_to
    picklist_with_radio_buttons_with_attachment_required_on_last_radio_button.save!

    yesno_with_comment_optional_on_yes = QuestionType::Boolean.new name: 'yesno_with_comment_optional_on_yes', title: 'Yes or No with Comment Optional on Yes'
    yesno_with_comment_optional_on_yes.question_rules.new mandatory: false, value: 'yes', capability: :add_comment, condition: :equal_to
    yesno_with_comment_optional_on_yes.save!


    #  fix yesnona_with_attachment_required_on_yes
    QuestionType.find_by_name('yesnona_with_attachment_required_on_yes').destroy
    qt = QuestionType::YesNoNa.new name: 'yesnona_with_attachment_required_on_yes', title: 'Yes, No, N/A with Attachment Required on Yes'
    qt.question_rules.new mandatory: true, value: 'yes', capability: :add_attachment, condition: :equal_to
    qt.save!

  end
end
