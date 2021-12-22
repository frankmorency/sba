class UpdateAnnualEligibilityTaxReturns < ActiveRecord::Migration
  def change
    Question.where(name: 'annual_review_tax_returns').first
            .update_attributes(title: "Please upload your firm's tax returns filed with the IRS for the last 3 years.")
  end
end