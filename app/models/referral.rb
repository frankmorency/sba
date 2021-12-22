class Referral
  include ActiveModel::Model

  attr_accessor :individual_id, :office_id

  def office
    BusinessUnit.find(office_id)
  end

  def individual
    User.find(individual_id)
  end
end