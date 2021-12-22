FactoryBot.define do
  factory :basic_application, class: SbaApplication::SimpleApplication do
    workflow_state 'draft'
    progress nil
    creator_id 1
    association :questionnaire, factory: :basic_questionnaire
    application_start_date Time.now
    screening_due_date 15.days.from_now.to_date
    after(:build) { |app| app.class.skip_callback(:create, :after, :copy_sections_and_rules) }
  end

  factory :persisted_application, class: SbaApplication::SimpleApplication do
    id 222
  end

  factory :application_status_type do
    name 'New'
    description 'Temp'
  end

  factory :sba_application, class: SbaApplication::SimpleApplication do
    workflow_state 'draft'
    association :organization, factory: :org_with_user
    association :questionnaire, factory: :dynamic_questionnaire, strategy: :find_or_create, name: 'dynamic_q'
    application_start_date Time.now
    creator_id 1
  end

  factory :sba_application_basic, class: SbaApplication::SimpleApplication do
    workflow_state 'draft'
    association :organization, factory: :organization_with_questionnaire, strategy: :find_or_create, duns_number: '23234'
    association :questionnaire, factory: :wosb_questionnaire
    application_start_date Time.now
    progress nil
    creator_id 1
    after(:build) { |app| app.class.skip_callback(:create, :after, :copy_sections_and_rules) }
  end

  factory :sba_application_wosb, class: SbaApplication::SimpleApplication do
    workflow_state 'draft'
    creator_id 1
    association :organization, factory: :organization, strategy: :find_or_create, duns_number: '23234'
    association :questionnaire, factory: :wosb_questionnaire
    application_start_date Time.now
    progress nil
  end

  factory :sba_application_wosb_skip, class: SbaApplication::SimpleApplication do
    workflow_state 'under_review'
    creator_id 1
    association :organization, factory: :organization, strategy: :find_or_create, duns_number: '23234'
    association :questionnaire, factory: :wosb_questionnaire
    application_start_date Time.now
    progress nil
    after(:build) do |app| 
      app.class.skip_callback(:create, :after, :copy_sections_and_rules)
    end
    is_current true
  end

  factory :eight_a_display_application_initial, class: SbaApplication::EightAInitial do
    creator_id 1
    association :organization, factory: :org_with_user
    association :questionnaire, factory: :eight_a_questionnaire, strategy: :find_or_create, name: 'eight_a'
    application_start_date Time.now
    progress nil
    is_current true
    after(:build) do |app|
      app.class.skip_callback(:create, :after, :copy_sections_and_rules)
    end
  end

  factory :eight_a_display_application_annual, class: SbaApplication::EightAAnnualReview do
    creator_id 1
    kind 'annual_review'
    association :organization, factory: :org_with_user
    association :questionnaire, factory: :eight_a_questionnaire, strategy: :find_or_create, name: 'eight_a'
    application_start_date Time.now
    progress nil
    is_current true
    after(:build) do |app|
      app.class.skip_callback(:create, :after, :copy_sections_and_rules)
    end
    # this is to bypass the validation
    to_create {|instance| instance.save(validate: false) }
  end

  factory :wosb_display_application, class: SbaApplication::SimpleApplication do
    creator_id 1
    association :questionnaire, factory: :wosb_questionnaire
    application_start_date Time.now
    progress nil
    is_current true
    association :certificate, factory: :wosb_cert
    after(:build) do |app|
      app.class.skip_callback(:create, :after, :copy_sections_and_rules)
    end
  end

  factory :mpp_display_application, class: SbaApplication::SimpleApplication do
    creator_id 1
    association :questionnaire, factory: :mpp_questionnaire
    application_start_date Time.now
    progress nil
    is_current true
    association :certificate, factory: :mpp_cert
    after(:build) do |app|
      app.class.skip_callback(:create, :after, :copy_sections_and_rules)
    end
  end

  factory :sba_8a_initial_application, class: SbaApplication::EightAInitial do
    creator_id 1
    workflow_state 'submitted'
    kind 'initial'
    association :organization, factory: :organization, strategy: :find_or_create, duns_number: '23234'
    association :questionnaire, factory: :wosb_questionnaire
    application_start_date Time.now
    progress nil
    is_current true
    association :certificate, factory: :certificate_eight_a_initial
    after(:build) do |app| 
      app.class.skip_callback(:create, :after, :copy_sections_and_rules)
    end
  end

  factory :fake_8a_app_with_active_cert, class: SbaApplication::EightAInitial do
    workflow_state 'submitted'
    kind 'initial'
    application_start_date Time.now
    progress nil
    is_current true
    after(:build) do |app|
      app.class.skip_callback(:create, :after, :copy_sections_and_rules)
      app.creator = app.organization.vendor_admin_user
      app.questionnaire = Questionnaire.find_by(name: 'eight_a_initial')
      app.root_section = build(:root_section, questionnaire: app.questionnaire, sba_application: app)
      app.first_section = build(:master_section, questionnaire: app.questionnaire, sba_application: app)
    end

    after(:create) do |app|
      cert = Certificate::EightA.new(organization: app.organization, workflow_state: 'active',
                                     certificate_type: CertificateType::EightA.first)
      cert.save validate: false
      app.update_attribute(:certificate_id, cert.id)
    end
  end
end
