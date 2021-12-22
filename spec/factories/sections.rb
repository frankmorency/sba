FactoryBot.define do
  factory :section_root, class: Section::Root do
    name 'section_root'
    title "Section Root"
    position  0
  end

  factory :master_section, class: Section::MasterApplicationSection do
    name 'master_section'
    title "Master Section"
    position  0
  end

  factory :section_deferrer, class: Section::QuestionSection do
    sequence(:name) { |n| "section_deferrer#{n}" }
    sequence(:title) { |n| "Section deferrer #{n}" }
    position  0
  end

  factory :deferred_section, class: Section::QuestionSection do
    sequence(:name) { |n| "deferred_section_#{n}" }
    sequence(:title) { |n| "Deferred Section #{n}" }
    position  0
  end

  factory :section_1, class: Section::QuestionSection do
    name 'section_1'
    title "Section 1"
    position  0
  end

  factory :section_1_1, class: Section::QuestionSection do
    name 'section_1_1'
    title "Section 1 1"
    position  0
  end

  factory :section_1_2, class: Section::QuestionSection do
    name 'section_1_2'
    title "Section 1 2"
    position  1
  end

  factory :section_2, class: Section::QuestionSection do
    name 'section_2'
    title "Section 2"
    position  1
  end

  factory :section_2_1, class: Section::QuestionSection do
    name 'section_2_1'
    title "Section 2 1"
    position  0
  end

  factory :section_2_2, class: Section::QuestionSection do
    name 'section_2_2'
    title "Section 2 2"
    position  1
  end

  factory :section_3, class: Section::QuestionSection do
    name 'section_3'
    title "Section 3"
    position  2
  end

  factory :am_i_eligible, class: Section do
    sequence(:name) { |n| "am_i_eligible_#{n}" }
    title 'Am I Eligible?'
    association :questionnaire, factory: :questionnaire, strategy: :find_or_create, name: 'am_i_eligible'
  end

  factory :section_template, class: Section::Template do
    name "section_template"
    title "{value} Template"
    association :questionnaire, factory: :questionnaire, strategy: :find_or_create, name: 'dynamic_q'
  end

  factory :question_section, class: Section::QuestionSection do
    sequence(:name) { |n| "question_section_#{n}" }
    sequence(:title) { |n| "Question Section #{n}" }
    association :questionnaire, factory: :questionnaire, strategy: :find_or_create, name: 'dynamic_q'
  end

  factory :root_section, class: Section::Root do
    sequence(:name) { |n| "app_section_#{n}" }
    sequence(:title) { |n| "App Section #{n}" }
    association :questionnaire, factory: :questionnaire, strategy: :find_or_create, name: 'dynamic_q'
  end

  factory :application_section, class: Section::ApplicationSection do
    sequence(:name) { |n| "app_section_#{n}" }
    sequence(:title) { |n| "App Section #{n}" }
    association :questionnaire, factory: :questionnaire, strategy: :find_or_create, name: 'dynamic_q'
  end

  factory :dynamic_section, class: Section::QuestionSection do
    sequence(:name) { |n| "dynamic_section_#{n}" }
    sequence(:title) { |n| "Dynamic Section #{n}" }
    dynamic true
    association :questionnaire, factory: :questionnaire, strategy: :find_or_create, name: 'dynamic_q'
  end

  factory :section_spawner, class: Section::Spawner do
    sequence(:name) { |n| "section_spawner_#{n}" }
    sequence(:title) { |n| "Section Spawner #{n}" }
    association :questionnaire, factory: :questionnaire, strategy: :find_or_create, name: 'dynamic_q'
  end

  factory :signature_section, class: Section::SignatureSection do
    sequence(:name) { |n| "sig_section_#{n}" }
    sequence(:title) { |n| "Sig Section #{n}" }
    association :questionnaire, factory: :questionnaire, strategy: :find_or_create, name: 'dynamic_q'
  end

  factory :review_section, class: Section::ReviewSection do
    sequence(:name) { |n| "review_section_#{n}" }
    sequence(:title) { |n| "Review Section #{n}" }
    association :questionnaire, factory: :questionnaire, strategy: :find_or_create, name: 'dynamic_q'
  end

  factory :reconsideration_section_1, class: Section::ReconsiderationSection do
    name 'reconsideration_784723984892_content'
    title "Reconsideration"
    position  0
    association :questionnaire, factory: :eight_a_questionnaire, strategy: :find_or_create, name: 'eight_a'
  end

  factory :reconsideration_section_2, class: Section::ReconsiderationSection do
    name 'reconsideration_892347844675_content'
    title "Reconsideration 2"
    position  1
    association :questionnaire, factory: :eight_a_questionnaire, strategy: :find_or_create, name: 'eight_a'
  end

  factory :reconsideration_section_3, class: Section::ReconsiderationSection do
    name 'reconsideration_365436247632_content'
    title "Reconsideration 3"
    position  2
    association :questionnaire, factory: :eight_a_questionnaire, strategy: :find_or_create, name: 'eight_a'
  end

  factory :master_section_2, class: Section::MasterApplicationSection do
    name 'master_section'
    title "Master Section"
    position  0
    association :questionnaire, factory: :eight_a_questionnaire, strategy: :find_or_create, name: 'eight_a'
  end
end
