FactoryBot.define do
  factory :question_type, class: 'QuestionType' do
    name "yesno"
    title "Yes or No"
  end

  factory :null_question_type, parent: :question_type, class: 'QuestionType::Null' do
    name "null"
  end

  factory :real_estate_type, parent: :question_type, class: 'QuestionType::RealEstate' do
    type 'QuestionType::RealEstate'
    name 'real_estate'
    title "Real Estate"
  end

  factory :repeating_question_type, parent: :question_type, class: 'QuestionType::RepeatingQuestion' do
    type 'QuestionType::RepeatingQuestion'
    name 'repeating_question'
    title "Repeating Question"
  end
  
  factory :composite_question_type, parent: :question_type, class: 'QuestionType::CompositeQuestion' do
    type 'QuestionType::CompositeQuestion'
    name 'composite_question'
    title "Composite Question"
  end

  factory :boolean_question, parent: :question_type, class: 'QuestionType::Boolean' do
    type 'QuestionType::Boolean'
    name 'yesno'
    title "Yes or No"
  end

  factory :yes_no_na_type, parent: :question_type, class: 'QuestionType::YesNoNa' do
    type 'QuestionType::YesNoNa'
    name 'yesnona'
    title "Yes No Na"
  end

  factory :address_type, parent: :question_type, class: 'QuestionType::Address' do
    type 'QuestionType::Address'
    name 'address'
    title "Address"
  end

  factory :naics_code_type, parent: :question_type, class: 'QuestionType::NaicsCode' do
    type 'QuestionType::NaicsCode'
    name 'naics'
    title "Naics Code"
  end

  factory :picklist_type, parent: :question_type, class: 'QuestionType::Picklist' do
    type 'QuestionType::Picklist'
    name 'picklist'
    title "Picklist"
  end

  factory :date_type, parent: :question_type, class: 'QuestionType::Date' do
    type 'QuestionType::Date'
    name 'date'
    title "Date"
  end

  factory :currency_type, parent: :question_type, class: 'QuestionType::Currency' do
    type 'QuestionType::Currency'
    name 'currency'
    title "Currency"
  end

  factory :percentage_type, parent: :question_type, class: 'QuestionType::Percentage' do
    type 'QuestionType::Percentage'
    name 'percentage'
    title "Percentage"
  end

  factory :naics_question, parent: :question_type, class: 'QuestionType::NaicsCode' do
    type 'QuestionType::NaicsCode'
    name 'naics_code'
    title "Naics Code"
  end

  factory :date_question_type, parent: :question_type, class: 'QuestionType::Date' do
    type 'QuestionType::Date'
    name 'date'
    title "Date Question"
  end

  factory :currency_question_type, parent: :question_type, class: 'QuestionType::Currency' do
    type 'QuestionType::Currency'
    name 'currency'
    title "Currency Question"
  end

  factory :address_question_type, parent: :question_type, class: 'QuestionType::Address' do
    type 'QuestionType::Address'
    name 'address'
    title "Address Question"
  end

  factory :boolean_question_type, parent: :question_type, class: 'QuestionType::Boolean' do
    type 'QuestionType::Boolean'
    name 'boolean'
    title "Boolean Question"
  end

  factory :owner_list_question_type, parent: :question_type, class: 'QuestionType::OwnerList' do
    type 'QuestionType::OwnerList'
    name 'OwnerList'
    title "OwnerList Question"
  end

  factory :naics_code_question_type, parent: :question_type, class: 'QuestionType::NaicsCode' do
    type 'QuestionType::NaicsCode'
    name 'NaicsCode'
    title "NaicsCode Question"
  end

  factory :table_question_type, parent: :question_type, class: 'QuestionType::Table' do
    type 'QuestionType::Table'
    name 'yesno_with_table_required_on_yes'
    title "Table 1"
  end

  factory :duns, parent: :question_type, class: 'QuestionType::Duns' do
    type 'QuestionType::Duns'
    name 'duns'
    title "This is duns question"
  end

  factory :text_field_single_line, parent: :question_type, class: 'QuestionType::TextField' do
    type 'QuestionType::TextField'
    name 'text_field_single'
    title 'Text Field Single Line'
    config_options {{num_lines: 'single'}}
  end

  factory :text_field_multiline, parent: :question_type, class: 'QuestionType::TextField' do
    type 'QuestionType::TextField'
    name 'text_field_multi'
    title 'Text Field Multiline'
    config_options {{num_lines: 'multi'}}
  end

  factory :text_field_invalid, parent: :question_type, class: 'QuestionType::TextField' do
    type 'QuestionType::TextField'
    name 'text_fieldsingleminmax'
    title 'Text Field Single with Min and Max'
    config_options {{num_lines: 'box', min: 'box'}}
  end

  factory :checkbox_question_type, parent: :question_type, class: 'QuestionType::Checkbox' do
    type 'QuestionType::Checkbox'
    name 'checkbox'
    title 'Checkbox'
  end

  factory :date_range_type, parent: :question_type, class: 'QuestionType::DateRange' do
    type 'QuestionType::DateRange'
    name 'date_range'
    title 'Date Range'
  end

  factory :data_entry_grid_type, parent: :question_type, class: 'QuestionType::DataEntryGrid' do
    type 'QuestionType::DataEntryGrid'
    name 'data entry grid'
    title 'Data Entry Grid'
  end

  factory :full_address_type, parent: :question_type, class: 'QuestionType::FullAddress' do
    type 'QuestionType::FullAddress'
    name 'full address'
    title 'Full Address'
  end

  factory :certify_editable_table_type, parent: :question_type, class: 'QuestionType::CertifyEditableTable' do
    type 'QuestionType::CertifyEditableTable'
    name 'certify editable table'
    title 'Certify Editable Table'
  end

end
