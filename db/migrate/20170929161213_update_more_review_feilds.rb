class UpdateMoreReviewFeilds < ActiveRecord::Migration
  def change
  	add_column :reviews, :determine_eligible, :boolean
    add_column :reviews, :determine_eligible_for_appeal, :boolean
  end
end
