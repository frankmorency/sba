FactoryBot.define do
  factory :answer do
  end

  factory :answer_boolean, class: Answer do
    association :question, factory: :yes_no_question, strategy: :find_or_create, name: 'yesno'

    value  { {'value' => 'yes'} }
    evaluated_response true
  end

  factory :answer_yes_no_na, class: Answer do
    association :question, factory: :yes_no_na_question, strategy: :find_or_create, name: 'yesnona'

    value  { {'value' => 'yes'} }
    evaluated_response true
  end

  factory :answer_address, class: Answer do
    association :question, factory: :address_question, strategy: :find_or_create, name: 'address'

    value  { {'value' => '2324 Main St. SE, Washington DC 20010'} }
    evaluated_response true
  end

  factory :answer_naics_code, class: Answer do
    association :question, factory: :naics_code_question, strategy: :find_or_create, name: 'naics_code'

    value  { {'value' => '2324 Main St. SE, Washington DC 20010'} }
    evaluated_response true
  end

  factory :answer_picklist, class: Answer do
    association :question, factory: :picklist_question, strategy: :find_or_create, name: 'picklist'

    value  { {'value' => 'Whatever'} }
    evaluated_response true
  end

  factory :answer_date, class: Answer do
    association :question, factory: :date_question, strategy: :find_or_create, name: 'date'

    value  { {'value' => '2010-12-23'} }
    evaluated_response true
  end

  factory :answer_currency, class: Answer do
    association :question, factory: :currency_question, strategy: :find_or_create, name: 'currency'

    value  { {'value' => '343.23'} }
    evaluated_response true
  end

  factory :answer_percentage, class: Answer do
    association :question, factory: :percentage_question, strategy: :find_or_create, name: 'percentage'

    value  { {'value' => '45.32'} }
    evaluated_response true
  end

  factory :answer_yes, class: Answer do
    association :owner, factory: :user, strategy: :find_or_create, id: 99

    value  { {'value' => 'yes'} }
    evaluated_response true
  end

  factory :answer_no, class: Answer do
    association :owner, factory: :user, strategy: :find_or_create, id: 99

    value  { {'value' => 'no'} }
    evaluated_response false
  end

  factory :answer_naics, class: Answer do
    association :owner, factory: :user, strategy: :find_or_create, id: 99

    value  { {'value' => '231244'} }
    evaluated_response true
  end

  factory :answer_naics_wrong, class: Answer do
    association :owner, factory: :user, strategy: :find_or_create, id: 99

    value  { {'value' => '123456'} }
    evaluated_response false
  end
end
