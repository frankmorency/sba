if Feature.active?(:elasticsearch)
  begin
    Rails.logger.info "Delete all CasesV2Index in ES"
    # Delete all indexes in ES
    #CasesIndex.delete!
    CasesV2Index.delete!
  rescue Exception => error
    Rails.logger.warn "Delete all CasesV2Index in ES Failed: #{error.message}"
  end
  Rails.logger.info "Recreate all CasesV2Index in ES"
  # Recreate all indexes in ES
  #CasesIndex.create!
  CasesV2Index.create!
  Rails.logger.info "Running CasesV2Index.import"
  # There should be nothing to import as we don't have an appication with a cert at this time.
  #CasesIndex.import
  CasesV2Index.import
end



Rails.logger.info "Make all seeded documents skip AV Scanner and Compression"
# Make all seeded documents skip AV Scanner and Compression
Document.update_all("av_status='OK', compressed_status='failed'")

# Seeding sample data for BDMIS Migration
#Questionnaire::EightAMigrated.load_from_csv!('db/fixtures/bdmis/initial_import')
#Questionnaire::EightAMigrated.load_from_csv!('db/fixtures/bdmis/sprint_2_import')

if Feature.active?(:elasticsearch)
  begin
    Rails.logger.info "Delete all AgencyRequirementsIndex in ES"
    # Delete all indexes in ES
    AgencyRequirementsIndex.delete!
  rescue Exception => error
    Rails.logger.warn "Delete all AgencyRequirementsIndex in ES Failed: #{error.message}"
  end
  Rails.logger.info "Recreate all AgencyRequirementsIndex in ES"
  # Recreate index in ES
  AgencyRequirementsIndex.create!
  # We do not import AgencyRequirementsIndex.import as the AgencyRequirement documents are added after this point (below).
end

# Seeding sample data for AgencyCo and AgencyRequirement.
# Currently Faker only works in dev :demo, :development, :qa, :training, :test
if %w(dev demo development qa training test).include? Rails.env
  Rails.logger.info "Seeding sample data for AgencyCo and AgencyRequirement."
  AgencyCo.create! first_name: Faker::Name.unique.first_name, last_name: Faker::Name.unique.last_name
  AgencyCo.create! first_name: Faker::Name.unique.first_name, last_name: Faker::Name.unique.last_name
  AgencyCo.create! first_name: Faker::Name.unique.first_name, last_name: Faker::Name.unique.last_name

  # Seeding sample data for AgencyRequirement. Most of the fields are associations with other models.
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

if Feature.active?(:elasticsearch)
  Rails.logger.info "Running AgencyRequirementsIndex import"
  AgencyRequirementsIndex.import
end

Rails.logger.info "SEEDS2 completed -- -- --"
