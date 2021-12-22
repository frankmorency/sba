class DutyStation < ActiveRecord::Base
  if Feature.active?(:elasticsearch)
    #Since DutyStation is seeded before agency_requirements is created we have to test for AgencyRequirement.table_exists?
    update_index("agency_requirements") { agency_requirements if AgencyRequirement.table_exists? }
  end

  acts_as_paranoid
  has_paper_trail

  # has_and_belongs_to_many :users
  has_many :offices
  has_many :users, through: :offices

  # has_and_belongs_to_many :access_requests
  has_many :office_requests
  has_many :access_requests, through: :office_requests

  has_and_belongs_to_many :sba_applications
  has_many :certificates

  has_many :agency_requirements

  def self.all_names
    DutyStation.order(:name).pluck(:name)
  end

  def self.stations_with_district_office_sba_users
    DutyStation.joins(users: :roles).uniq.where(roles: { name: ["sba_supervisor_8a_district_office", "sba_analyst_8a_district_office", "sba_director_8a_district_office", "sba_deputy_director_8a_district_office"] }).order("name ASC")
  end

  def short_name
    name.parameterize
  end
end
