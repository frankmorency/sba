class EightADetermination
  include ActiveModel::Model

  attr_accessor :individual_id, :determine_eligible, :determine_eligible_for_appeal, :deliver_to, :subject, :message, :app

  def individual
    User.find(individual_id)
  end

  def decision
    determine_eligible == "true" ? "Eligible" : "Ineligible"
  end
end
