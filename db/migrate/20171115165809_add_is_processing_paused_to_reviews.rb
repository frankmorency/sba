class AddIsProcessingPausedToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :processing_paused, :boolean, default: false # indicates if the review processing has been paused
    add_column :reviews, :processing_pause_date, :date # indicates date that processing was paused
    Review.reset_column_information
  end
end
