class AddProcessingDueDateToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :processing_due_date, :date
  end
end
