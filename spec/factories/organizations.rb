FactoryBot.define do
  factory :vendor_admin_org, class: Organization do
    duns_number {|n| "DUNS#{n}" }
    tax_identifier {|n| "EIN#{n}" }
    tax_identifier_type 'EIN'
    business_type 'llc'
  end

  factory :org_with_user, class: Organization do
    sequence(:duns_number) {|n| "DUNS_123_#{Time.now.to_i}_#{n}" }
    sequence(:tax_identifier) {|n| "EIN123456_#{n}" }
    tax_identifier_type 'EIN'
    business_type 'llc'
    after(:build) {|organization| organization.users << build(:vendor_user) }
  end

  factory :organization do
    sequence(:duns_number) {|n| "DUNS_#{Time.now.to_i}_#{n}" }
    sequence(:tax_identifier) {|n| "EIN#{n}" }
    tax_identifier_type 'EIN'
    business_type 'llc'
  end

  # TODO merge into :organization
  factory :organization_eight_a, class: Organization do
    duns_number {|n| "DUNS#{n}" }
    tax_identifier {|n| "EIN#{n}" }
    tax_identifier_type 'EIN'
    business_type 'llc'
  end

  factory :user_assoc, class: Organization do
    duns_number 'DUNS1'
    tax_identifier 'EIN1'
    tax_identifier_type 'EIN'
  end

  factory :organization_with_questionnaire, class: Organization do
    duns_number 'DUNS1'
    tax_identifier 'EIN1'
    tax_identifier_type 'EIN'
    business_type 'llc'
    #association :questionnaire, factory: :basic_questionnaire
  end
end
