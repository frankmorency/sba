FactoryBot.define do
  factory :question_presentation do
  end

  factory :real_estate_question_presentation, class: QuestionPresentation do
    association :section, factory: :question_section
    association :question, factory: :real_estate_question

    helpful_info {{}}

    position 1
  end

  factory :amieligible_pres_1, class: QuestionPresentation do
    association :section, factory: :am_i_eligible, strategy: :find_or_create, name: 'am_i_eligible'
    association :question, factory: :wosb_question_1, strategy: :find_or_create, name: 'us_citizen'

    helpful_info {{}}

    position 1
  end

  factory :amieligible_pres_2, class: QuestionPresentation  do
    association :section, factory: :am_i_eligible, strategy: :find_or_create, name: 'am_i_eligible'
    association :question, factory: :wosb_question_2, strategy: :find_or_create, name: 'women_owning_business'

    helpful_info {{}}

    position 2
  end

  factory :amieligible_pres_3, class: QuestionPresentation  do
    association :section, factory: :am_i_eligible, strategy: :find_or_create, name: 'am_i_eligible'
    association :question, factory: :edwosb_question_1, strategy: :find_or_create, name: 'naic_code'

    helpful_info {{}}

    position 3
  end
end
