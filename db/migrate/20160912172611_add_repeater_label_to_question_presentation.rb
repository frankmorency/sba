class AddRepeaterLabelToQuestionPresentation < ActiveRecord::Migration
  def change
    add_column :question_presentations, :repeater_label, :text # Text to be displayed for repeating questions (Add an "item") for instance - see US1418
    add_column :question_presentations, :minimum, :integer # Minimum number of answers for this question - see US1418
    add_column :question_presentations, :maximum, :integer # Maximum number of answers for this question - see US1418
  end
end
