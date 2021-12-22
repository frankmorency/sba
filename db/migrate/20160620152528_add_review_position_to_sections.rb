class AddReviewPositionToSections < ActiveRecord::Migration
  def change
    # review position is added to make it easier to present the question review page with properly ordered sections and questions to analysts
    add_column :sections, :review_position, :integer
    Section.reset_column_information
  end
end
