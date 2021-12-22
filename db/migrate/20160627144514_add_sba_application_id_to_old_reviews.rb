class AddSbaApplicationIdToOldReviews < ActiveRecord::Migration
  def change
    Review.where(sba_application_id: nil).each do |review|
      review.update_attribute(:sba_application_id, review.certificate.current_application.id)
    end
  end
end
