FactoryBot.define do
  factory :question do
    name 'person'
    title 'Are you a person?'
    association :question_type, factory: :boolean_question, strategy: :find_or_create, name: 'yesno'
  end

  factory :real_estate_question, class: Question do
    association :question_type, factory: :real_estate_type, strategy: :find_or_create, name: 'real_estate'

    sequence(:name) {|n| "primary_real_estate_#{n}" }
    sequence(:title) {|n| "Real Estate Details #{n}?" }

    multi true

    sub_questions [
        {
            question_type: 'picklist', name: 'real_estate_type', position: 0, title: 'What type of Other Real Estate do you own?', possible_values: ['Other Residential', 'Commercial', 'Industrial', 'Land', 'Other Real Estate']
        },
        {
            question_type: 'address', name: 'real_estate_address', position: 1, title: 'What is the address of your Other Real Estate?'
        },
        {
            question_type: 'yesno', name: 'real_estate_jointly_owned', position: 2, title: 'Is your Other Real Estate jointly owned?'
        },
        {
            question_type: 'percentage', name: 'real_estate_jointly_owned_percent', position: 3, title: 'What percentage of ownership do you have in your Other Real Estate?'
        },
        {
            question_type: 'percentage', name: 'real_estate_percent_of_mortgage', position: 4, title: 'What percentage of the mortgage are you responsible for in your Other Real Estate?'
        },
        {
            question_type: 'currency', name: 'real_estate_value', position: 5, title: 'What is the current value of your Other Real Estate?'
        },
        {
            question_type: 'currency', name: 'real_estate_mortgage_balance', position: 6, title: 'What is the mortgage balance on your Other Real Estate?'
        },
        {
            question_type: 'yesno', name: 'real_estate_second_mortgage', position: 7, title: 'Is there a lean, 2nd mortgage or Home Equity Line of Credit on your Other Real Estate?'
        },
        {
            question_type: 'currency', name: 'real_estate_second_mortgage_value', position: 8, title: 'What is the current balance of the lean(s)?'
        },
        {
            question_type: 'yesno', name: 'real_estate_rent_income', position: 9, title: 'Do you receive income from your Other Real Estate (rent, etc.)?'
        },
        {
            question_type: 'currency', name: 'real_estate_rent_income_value', position: 10, title: 'What is the income YOU receive from your Other Real Estate (calculated annually)?'
        }
    ]
  end

  factory :yes_no_question, class: Question do
    association :question_type, factory: :boolean_question, strategy: :find_or_create, name: 'yesno'

    sequence(:name) {|n| "yes_or_no_#{n}" }
    sequence(:title) {|n| "Do you like the number #{n}?" }
  end

  factory :yes_no_na_question, class: Question do
    association :question_type, factory: :yes_no_na_type, strategy: :find_or_create, name: 'yesnona'

    sequence(:name) {|n| "yes_no_na_#{n}" }
    sequence(:title) {|n| "Do you like the number #{n}?" }
  end


  factory :address_question, class: Question do
    association :question_type, factory: :address_type, strategy: :find_or_create, name: 'address'

    sequence(:name) {|n| "address_#{n}" }
    sequence(:title) {|n| "What's your address #{n}?" }
  end

  factory :naics_code_question, class: Question do
    association :question_type, factory: :naics_code_type, strategy: :find_or_create, name: 'naics_code'

    sequence(:name) {|n| "naics_code_#{n}" }
    sequence(:title) {|n| "What's your naics code #{n}?" }
  end

  factory :picklist_question, class: Question do
    association :question_type, factory: :picklist_type, strategy: :find_or_create, name: 'picklist'

    sequence(:name) {|n| "picklist_#{n}" }
    sequence(:title) {|n| "What do you pick #{n}?" }
  end

  factory :date_question, class: Question do
    association :question_type, factory: :date_type, strategy: :find_or_create, name: 'date'

    sequence(:name) {|n| "date_#{n}" }
    sequence(:title) {|n| "What's your b-day #{n}?" }
  end

  factory :currency_question, class: Question do
    association :question_type, factory: :currency_type, strategy: :find_or_create, name: 'currency'

    sequence(:name) {|n| "currency_#{n}" }
    sequence(:title) {|n| "How much do you make #{n}?" }
  end

  factory :percentage_question, class: Question do
    association :question_type, factory: :percentage_type, strategy: :find_or_create, name: 'percentage'

    sequence(:name) {|n| "percentage_#{n}" }
    sequence(:title) {|n| "How real are you #{n}?" }
  end

  factory :wosb_question_1, class: Question do
    association :question_type, factory: :boolean_question, strategy: :find_or_create, name: 'yesno'

    name 'us_citizen'
    title 'Are you a US Citizen?'
  end

  factory :wosb_question_2, class: Question do
    association :question_type, factory: :boolean_question, strategy: :find_or_create, name: 'yesno'

    name 'women_owning_business'
    title 'As woman owned business, do you and/or other women directly own at least 51% of the business?'
  end

  factory :edwosb_question_1, class: Question do
    association :question_type, factory: :naics_question, strategy: :find_or_create, name: 'naics_code'

    name 'naic_code'
    title 'Enter your primary NAICS Code'
    #lookup "{\"table_name\":\"eligible_naic_code\",\"filter_column_name\":\"certificate_type_id\",\"filter_value\":\"1\",\"target_column\":\"naic_code\"}"
  end

  factory :table_question_1, class: Question do
    association :question_type, factory: :table_question_type, strategy: :find_or_create, name: 'yesno_with_table_required_on_yes'

    sequence(:name) { |n| "table_#{n}_question"}
    title 'Enter your details in below table'
    #lookup "{\"table_name\":\"eligible_naic_code\",\"filter_column_name\":\"certificate_type_id\",\"filter_value\":\"1\",\"target_column\":\"naic_code\"}"
  end

  factory :table_question_1_strategy_notes_receivables, class: Question do
    association :question_type, factory: :table_question_type, strategy: :find_or_create, name: 'yesno_with_table_required_on_yes'

    sequence(:name) { |n| "table_#{n}_question_with_strategy"}
    title 'Enter your details in below table'
    strategy 'NotesReceivables'
    #lookup "{\"table_name\":\"eligible_naic_code\",\"filter_column_name\":\"certificate_type_id\",\"filter_value\":\"1\",\"target_column\":\"naic_code\"}"
  end
end
