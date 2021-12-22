FactoryBot.define do
  factory :review do
    type 'Review'
    case_number 'A123456789'
    workflow_state 'draft'
    trait :skip_validate do
      to_create {|instance| instance.save(validate: false)}
    end
  end

  factory :review_for_determination, class: Review do
    type 'Review::Initial'
    case_number 'A123456780'
    workflow_state 'recommend_eligible'

    after(:build) do |review|
      cert = build(:certificate_for_determination).save(validate: false)
      review.certificate = Certificate.first
    end
  end

  factory :review_for_eight_a, class: Review::EightAInitial  do
    case_number 'PM1502394769'
    after(:build) do |review|
      review.certificate = Certificate.first
      current_assignment = Assignment.first
    end
  end
end
