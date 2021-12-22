FactoryBot.define do
  factory :agency_requirement do
    user
    agency_office_id AgencyOffice.order("RANDOM()").first.id
    agency_contract_type_id AgencyContractType.order("RANDOM()").first.id
    sequence(:title) {|n| "TITLE_#{n}" }
    sequence(:description) {|n| "DESC_#{n}" }
    received_on Time.now
    estimated_contract_value 20000
    contract_value 10000
    offer_solicitation_number 123
  end

  factory :agency_requirement_with_organizations, class: AgencyRequirement do    
    user
    agency_office_id AgencyOffice.order("RANDOM()").first.id
    agency_contract_type_id AgencyContractType.order("RANDOM()").first.id
    sequence(:title) {|n| "TITLE_#{n}" }
    sequence(:description) {|n| "DESC_#{n}" }
    received_on Time.now
    estimated_contract_value 20000
    contract_value 10000
    offer_solicitation_number 123    
    association :agency_requirement_organizations, factory: :agency_requirement_organization
  end

end
