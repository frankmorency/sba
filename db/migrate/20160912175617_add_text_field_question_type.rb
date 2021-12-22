class AddTextFieldQuestionType < ActiveRecord::Migration
  def change
    
    text_field_single = QuestionType::TextField.new(name: 'text_field_single_line',
                                                    title: 'Text Field Single Line',
                                                    config_options: {num_lines: 'single'})
    text_field_single.save!

    text_field_multi = QuestionType::TextField.new(name: 'text_field_multiline',
                                                   title: 'Text Field Multiline',
                                                   config_options: {num_lines: 'multi'})
    text_field_multi.save!
  end
end
