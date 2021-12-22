class AddColumnReconsiderationOrAppealClockToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :reconsideration_or_appeal_clock, :datetime
  end
end
