class UpdateAnnualReviewFinancials < ActiveRecord::Migration
  def change
    Question.where(name: 'annual_review_financials').first
            .update_attributes(title: "Upload your firm’s year-end balance sheet and income statements (profit and loss statements) for the last 3 fiscal years.")
  end
end
