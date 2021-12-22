FactoryBot.define do
  factory :questionnaire, class: Questionnaire::SimpleQuestionnaire do
    name "am_i_eligible"
    title "Am I Eligible?"
    review_page_display_title "Program Self-Certification Summary"
    human_name 'AIE'
    link_label "Am I Eligible"
    maximum_allowed 1

    association :certificate_type, factory: :ami_cert
  end

  factory :dynamic_questionnaire, class: Questionnaire::SimpleQuestionnaire do
    name "dynamic_q"
    title "Dynamic Questionnaire"
    review_page_display_title "Program Self-Certification Summary"
    human_name 'DQ'
    link_label "Dynamic Questionnaire"
    association :certificate_type, factory: :dynamic_cert, strategy: :find_or_create, name: 'dyanmic'
    maximum_allowed 1
  end

  factory :basic_questionnaire, class: Questionnaire::SimpleQuestionnaire do
    name 'basic_q'
    title 'Basic Questionnaire'
    review_page_display_title "Program Self-Certification Summary"
    human_name 'BQ'
    link_label 'Basic Questionnaire'
    association :certificate_type, factory: :basic_cert, strategy: :find_or_create, name: 'basic'
    maximum_allowed 1
  end

  factory :wosb_questionnaire, class: Questionnaire::SimpleQuestionnaire do
    name 'wosb_q'
    title 'Wosb Questionnaire'
    review_page_display_title "Women-Owned Small Business Program Self-Certification Summary"
    human_name 'WOSB'
    link_label "WOSB Self-Certification"
    maximum_allowed 1

    association :program, factory: :program_wosb, strategy: :find_or_create, name: 'wosb'
    association :certificate_type, factory: :wosb_cert
  end

  factory :mpp_questionnaire, class: Questionnaire::SimpleQuestionnaire do
    name 'mpp_q'
    title 'MPP Questionnaire'
    review_page_display_title "MPP"
    human_name 'MPP'
    link_label "MPP Self-Certification"
    maximum_allowed 2
    association :program, factory: :program_mpp, strategy: :find_or_create, name: 'mpp'
  end


  factory :eight_a_questionnaire, class: Questionnaire::SimpleQuestionnaire do
    name 'eight_a'
    title '8(a) Questionnaire'
    review_page_display_title "8(a)"
    human_name '8(a)'
    link_label "8(a) Self-Certification"
    maximum_allowed 1
    association :program, factory: :program_eight_a, strategy: :find_or_create, name: 'eight_a'
  end
end
