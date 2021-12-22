class CreatingTextFieldMultilineWithAttachmentOptional < ActiveRecord::Migration
  def change
    # Adding new question type 
    text_and_attachment_optional = QuestionType::TextField.new(name: 'text_field_multiline_with_attachment_optional',
                                      title: 'Text Field Multiline With Attachment Optional',
                                      config_options: {num_lines: 'multi'})
    text_and_attachment_optional.question_rules.new mandatory: false, value: 'na',capability: :add_attachment, condition: :equal_to
    text_and_attachment_optional.save!
  end
end
