FactoryBot.define do
  factory :agency_requirement_organization do    
    association :agency_requirement, factory: :agency_requirement    
    association :organization, factory: :organization    
  end
end
