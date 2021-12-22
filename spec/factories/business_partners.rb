FactoryBot.define do
  factory :business_partner do
    association :sba_application, factory: :sba_application
    first_name 'Mike'
    last_name 'Cowden'
    ssn '212-22-4444'
    email 'mcowden@asdf.com'
    title 0
    marital_status 0
    address '12 main way'
    city 'baltimore'
    country 'usa'
    state 'md'
    postal_code '30303'
    home_phone '555-1212'
    business_phone '595-4434'
  end
end
