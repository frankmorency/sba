class UpdateReviewFeilds < ActiveRecord::Migration
  def change
    add_column :reviews, :recommend_eligible, :boolean
    add_column :reviews, :recommend_eligible_for_appeal, :boolean
  end
end
