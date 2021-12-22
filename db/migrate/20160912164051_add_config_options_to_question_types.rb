class AddConfigOptionsToQuestionTypes < ActiveRecord::Migration
  def change
    add_column :question_types, :config_options, :json # configuration options for the single / multiline text field questions (holds the character limit, etc.)
    QuestionType.reset_column_information
  end
end
