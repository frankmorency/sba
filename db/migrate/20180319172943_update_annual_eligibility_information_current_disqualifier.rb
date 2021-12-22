class UpdateAnnualEligibilityInformationCurrentDisqualifier < ActiveRecord::Migration
  def change
    Disqualifier.where(message: "Your firm/'s information in <a href='https://www.sam.gov/portal/SAM/##11' target='_blank'>SAM.gov</a> must be current at the time of your annual review.").first
                .update_attributes(message: "You must update your information in <a href='https://www.sam.gov/portal/SAM/##11' target='_blank'>SAM.gov</a> before doing your annual review.")
  end
end
