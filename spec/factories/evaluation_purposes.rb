FactoryBot.define do
  factory :evaluation_purpose do
    name "am_i_eligible_wosb"
    title "Women Owned Small Business"
  end

  factory :am_i_eligible_wosb, class: EvaluationPurpose do
    name "am_i_eligible_wosb"
    title "Women Owned Small Business"
    association :certificate_type, factory: :wosb_cert, strategy: :find_or_create, name: 'wosb'
  end

  factory :am_i_eligible_edwosb, class: EvaluationPurpose do
    name "am_i_eligible_edwosb"
    title "Economically Disadvantaged Women Owned Small Business"
    association :certificate_type, factory: :wosb_cert, strategy: :find_or_create, name: 'edwosb'
  end
end
