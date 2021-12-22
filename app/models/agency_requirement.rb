class AgencyRequirement < ActiveRecord::Base
  include AgencyRequirementCSV
  if Feature.active?(:elasticsearch)
    update_index("agency_requirements") { self }
  end

  strip_attributes

  acts_as_paranoid
  has_paper_trail

  belongs_to :user
  belongs_to :duty_station
  belongs_to :program
  belongs_to :agency_office
  belongs_to :agency_offer_code
  belongs_to :agency_naics_code
  belongs_to :agency_offer_scope
  belongs_to :agency_offer_agreement
  belongs_to :agency_contract_type
  belongs_to :agency_co
  has_many :agency_requirement_documents
  has_many :agency_requirement_organizations
  has_many :organizations, through: :agency_requirement_organizations
  has_many :event_logs, as: :loggable

  before_validation :set_unique_number, on: :create
  after_create -> { write_log(:created) }
  after_update -> { write_log(:updated) }

  validates :title, presence: true
  validates :contract_awarded, inclusion: { in: [false, true], message: "%{value} is not a valid contract awarded value" }
  validates :agency_office, presence: true
  validates :agency_contract_type, presence: true
  validates :unique_number, presence: true, uniqueness: true

  accepts_nested_attributes_for :agency_requirement_organizations, allow_destroy: true

  # Name of the logical S3 folder where the agency_requirement_documents will be saved.
  def folder_name
    "agency_requirement_#{self.id}"
  end

  private

  def set_unique_number
    self.unique_number = "#{("A".."Z").to_a[rand(26)]}#{("A".."Z").to_a[rand(26)]}#{Time.now.to_i}#{("A".."Z").to_a[rand(26)]}"
  end

  def write_log(event)
    self.event_logs.create(user_id: user_id, event: event)
  end

  def user_id
    user.present? ? user.id : nil
  end
end
