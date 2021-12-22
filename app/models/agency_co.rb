class AgencyCo < ActiveRecord::Base
  strip_attributes
  acts_as_paranoid
  has_paper_trail

  has_many :agency_requirements

  validates :first_name, presence: true
  validates :last_name, presence: true
end
