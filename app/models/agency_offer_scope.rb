class AgencyOfferScope < ActiveRecord::Base
  if Feature.active?(:elasticsearch)
    update_index('agency_requirements') { agency_requirements }
  end

  strip_attributes
  acts_as_paranoid

  has_many  :agency_requirements

  validates :name, presence: true, uniqueness: true
end