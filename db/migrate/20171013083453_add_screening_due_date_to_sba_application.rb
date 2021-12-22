class AddScreeningDueDateToSbaApplication < ActiveRecord::Migration
  def change
    add_column :sba_applications, :screening_due_date, :date # the due date for the screening
  end
end
