class AgencyOfferAgreement < ActiveRecord::Base
  strip_attributes
  acts_as_paranoid

  has_many  :agency_requirements

  validates :name, presence: true, uniqueness: true
end