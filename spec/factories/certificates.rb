FactoryBot.define do
  factory :certificate_for_determination, class: Certificate::Wosb do
    workflow_state 'active'
    association :organization, factory: :organization, strategy: :find_or_create, duns_number: '23234'
    association :certificate_type, factory: :eight_a_cert_type, strategy: :find_or_create, name: 'eight_a'
  end

  factory :certificate_wosb, class: Certificate::EightA do
    workflow_state "active"
    association :certificate_type, factory: :wosb_cert
  end

  factory :certificate_mpp, class: Certificate::EightA do
    workflow_state "active"
    association :certificate_type, factory: :mpp_cert
  end

  factory :certificate_eight_a_initial, class: Certificate::EightA do
    workflow_state "screening"
    organization_id 1
    association :certificate_type, factory: :eight_a_cert_type, strategy: :find_or_create, name: 'eight_a'
    # this is to bypass the validation
    to_create {|instance| instance.save(validate: false) }
  end

  factory :certificate_eight_a, class: Certificate::EightA do
    workflow_state 'pending'
    association :organization, factory: :organization, strategy: :find_or_create, duns_number: '23234'
    association :certificate_type, factory: :eight_a_cert_type, strategy: :find_or_create, name: 'eight_a'
  end

  factory :eight_a_certificate_determination, class: Certificate::EightA do
    workflow_state 'pending'
    association :organization, factory: :organization_eight_a
    association :certificate_type, factory: :eight_a_cert_type, strategy: :find_or_create, name: 'eight_a'
    # this is to bypass the validation
    to_create {|instance| instance.save(validate: false) }
  end
end
