class AgencyRequirementOrganization < ActiveRecord::Base
  if Feature.active?(:elasticsearch)
    update_index("agency_requirements") { agency_requirement }
  end

  acts_as_paranoid
  has_paper_trail

  belongs_to :agency_requirement
  belongs_to :organization

  validates :agency_requirement_id, presence: true
  validates :organization_id, presence: true
end
