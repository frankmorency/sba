class AddNewReviewerIdToAssessment < ActiveRecord::Migration
  def change
    add_column :assessments, :new_reviewer_id, :integer # stores the id of the new current reviewer
  end
end