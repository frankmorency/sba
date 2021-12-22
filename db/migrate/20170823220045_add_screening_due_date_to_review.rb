class AddScreeningDueDateToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :screening_due_date, :date # the due date for the screening
  end
end
