class Recommendation
  include ActiveModel::Model

  attr_accessor :individual_id, :recommend_eligible, :recommend_eligible_for_appeal

  def individual
    User.find(individual_id)
  end

  def decision
    recommend_eligible == "true" ? "Eligible" : "Ineligible"
  end
end
