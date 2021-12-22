FactoryBot.define do
  factory :applicable_question do
  end

  factory :wosb_aq_1, class: ApplicableQuestion do
    association :evaluation_purpose, factory: :am_i_eligible_wosb, strategy: :find_or_create, name: 'am_i_eligible_wosb'
    association :question, factory: :wosb_question_1, strategy: :find_or_create, name: 'us_citizen'

    positive_response 'yes'
  end

  factory :wosb_aq_2, class: ApplicableQuestion do
    association :evaluation_purpose, factory: :am_i_eligible_wosb, strategy: :find_or_create, name: 'am_i_eligible_wosb'
    association :question, factory: :wosb_question_2, strategy: :find_or_create, name: 'women_owning_business'

    positive_response 'yes'
  end

  # hard coding filter value here
  factory :edwosb_aq_1, class: ApplicableQuestion do
    association :evaluation_purpose, factory: :am_i_eligible_edwosb, strategy: :find_or_create, name: 'am_i_eligible_edwosb'
    association :question, factory: :wosb_question_1, strategy: :find_or_create, name: 'us_citizen'

    positive_response 'yes'
  end

  factory :edwosb_aq_2, class: ApplicableQuestion do
    association :evaluation_purpose, factory: :am_i_eligible_edwosb, strategy: :find_or_create, name: 'am_i_eligible_edwosb'
    association :question, factory: :edwosb_question_1, strategy: :find_or_create, name: 'naic_code'

    positive_response 'yes'
  end
end
