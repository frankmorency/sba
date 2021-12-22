require 'rails_helper'
require 'rake'

# This module creates the agency_requirements_index in test.
# It also determines if the database has data and elasticsearch has indexes to run these specs.
module AgencyRequirementsSearchSpecHelper

  def self.setup_data
    return if data_exists? # We already have the data, does not need the setup

    # Adding sample data for AgencyCo and AgencyRequirement.
    AgencyCo.create! first_name: Faker::Name.unique.first_name, last_name: Faker::Name.unique.last_name
    AgencyCo.create! first_name: Faker::Name.unique.first_name, last_name: Faker::Name.unique.last_name
    AgencyCo.create! first_name: Faker::Name.unique.first_name, last_name: Faker::Name.unique.last_name

    unless associated_models_exists?
      puts "AgencyRequirementsSearchSpecHelper::setup_data - one or more of the associated models is not seeded. Exiting"
      return #Models associated with AgencyRequirement need to have data through seeding, hence returning.
    end

    # Adding sample data for AgencyRequirement. Most of the fields are associations with other models.
    100.times {
      agency_req = AgencyRequirement.create({:user_id => User.last.id,
                                             :duty_station_id => DutyStation.order("RANDOM()").first.id,
                                             :agency_naics_code_id => AgencyNaicsCode.order("RANDOM()").first.id,
                                             :agency_office_id => AgencyOffice.order("RANDOM()").first.id,
                                             :agency_offer_code_id => AgencyOfferCode.order("RANDOM()").first.id,
                                             :agency_offer_scope_id => AgencyOfferScope.order("RANDOM()").first.id,
                                             :agency_offer_agreement_id => AgencyOfferAgreement.order("RANDOM()").first.id,
                                             :agency_contract_type_id => AgencyContractType.order("RANDOM()").first.id,
                                             :agency_co_id => AgencyCo.order("RANDOM()").first.id,
                                             :title => Faker::Company.unique.name + " " + Faker::Company.suffix,
                                             :unique_number => "#{('A'..'Z').to_a[rand(26)]}#{('A'..'Z').to_a[rand(26)]}#{Time.now.to_i}#{('A'..'Z').to_a[rand(26)]}",
                                             :description => Faker::Twitter.status[:text],
                                             :received_on => Faker::Date.backward(4),
                                             :estimated_contract_value => 20000,
                                             :contract_value => 20000,
                                             :offer_solicitation_number => 211,
                                             :offer_value => Faker::Twitter.status[:text],
                                             :contract_number => Faker::Twitter.status[:text],
                                             :agency_comments => Faker::Twitter.status[:text],
                                             :contract_comments => Faker::Twitter.status[:text],
                                             :comments => Faker::Twitter.status[:text],
                                             :contract_awarded => [true, false].sample})
      AgencyRequirementOrganization.create(agency_requirement_id: agency_req.id, organization_id: Organization.all.first.id)
      AgencyRequirementOrganization.create(agency_requirement_id: agency_req.id, organization_id: Organization.all.last.id)
    }
  end

  def self.setup_index
    Rails.application.load_tasks
    Rake.application.invoke_task('chewy:reset[agency_requirements]')
    Rake.application.invoke_task('chewy:update_agency_requirements_index')
  rescue StandardError => e
    puts "AgencyRequirementsSearchSpecHelper::setup_index " + e.message
  end

  def self.associated_models_exists?
    models = [User, DutyStation, AgencyNaicsCode, AgencyOffice, AgencyOfferCode, AgencyOfferScope,
              AgencyOfferAgreement, AgencyContractType, AgencyCo]

    models.inject(true) {|result, model|
      result && model.send(:exists?)
    }
  end

  def self.data_exists?
    AgencyRequirement.exists?
  end

  def self.index_exists?
    AgencyRequirementsIndex::AgencyRequirement.total_count > 0
  end

  def self.can_run?
    data_exists? && index_exists?
  end
end

RSpec.describe AgencyRequirementsSearch, type: :model do

  RSpec.configure do |c|
    AgencyRequirementsSearchSpecHelper.setup_data
    AgencyRequirementsSearchSpecHelper.setup_index
    c.filter_run_excluding :can_run => !AgencyRequirementsSearchSpecHelper.can_run?
  end

  describe "#search", :can_run => true   do

    let(:agency_requirement) { AgencyRequirement.first }

    it 'should search by dun' do
      results = AgencyRequirementsSearch.new.search(agency_requirement.agency_requirement_organizations.map(&:organization).first.duns_number, 0, 1)
      expect(results.size).to eq(1)
    end

    it 'should search by title' do
      results = AgencyRequirementsSearch.new.search(agency_requirement.title, 0, 1)
      expect(results.size).to eq(1)
    end

    it 'should search by naics' do
      results = AgencyRequirementsSearch.new.search(agency_requirement.organization.primary_naics, 0, 1)
      expect(results.size).to eq(1)
    end

    it 'should filter on duty_station' do
      results = AgencyRequirementsSearch.new.search('', 0, 1, {"duty_station":agency_requirement.duty_station.name})
      expect(results.size).to eq(1)
    end

    it 'should allow multiple filters' do
      options = {
          duty_station: agency_requirement.duty_station.name,
          agency_office: agency_requirement.agency_office.name,
          agency_offer_code: agency_requirement.agency_offer_code.name,
          agency_contract_type: agency_requirement.agency_contract_type.name
      }
      results = AgencyRequirementsSearch.new.search('', 0, 1, options)
      result = results.first
      expect(results.size).to eq(1)
      expect(result.duty_station["name"]).to eq(agency_requirement.duty_station.name)
      expect(result.agency_office["name"]).to eq(agency_requirement.agency_office.name)
      expect(result.agency_offer_code["name"]).to eq(agency_requirement.agency_offer_code.name)
      expect(result.agency_contract_type["name"]).to eq(agency_requirement.agency_contract_type.name)
    end
  end
end