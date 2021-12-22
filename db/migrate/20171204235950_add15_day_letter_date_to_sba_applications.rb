class Add15DayLetterDateToSbaApplications < ActiveRecord::Migration
  def change
    add_column  :reviews, :letter_due_date, :date, null: true
  end
end
