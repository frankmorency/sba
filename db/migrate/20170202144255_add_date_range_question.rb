class AddDateRangeQuestion < ActiveRecord::Migration
  def change
    QuestionType::DateRange.create! name: 'date_range', title: 'DateRange'
  end
end
