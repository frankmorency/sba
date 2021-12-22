class CreatingQuestionsTypesYesnoWithAttachmentRequiredOnNo < ActiveRecord::Migration
  def change
    # "yesno_with_attachment_required_on_no"
    qt = QuestionType::Boolean.new name: 'yesno_with_attachment_required_on_no', title: 'Yes, No with Attachments Required on No'
    qt.question_rules.new mandatory: true, value: 'no', capability: :add_attachment, condition: :equal_to
    qt.save!

    # "yesnona_with_comment_required_on_yes"
    qt = QuestionType::YesNoNa.new name: 'yesnona_with_comment_required_on_yes', title: 'Yes, No, N/A with Comments Required on Yes'
    qt.question_rules.new mandatory: true, value: 'yes', capability: :add_comment, condition: :equal_to
    qt.save!

    #  "yesnona_with_attachment_required_on_yes"
    qt = QuestionType::YesNoNa.new name: 'yesnona_with_attachment_required_on_yes', title: 'Yes, No, N/A with Attachment Required on Yes'
    qt.question_rules.new mandatory: true, value: 'yes', capability: :add_comment, condition: :equal_to
    qt.save!
  end
end
