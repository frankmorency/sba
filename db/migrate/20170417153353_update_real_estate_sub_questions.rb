class UpdateRealEstateSubQuestions < ActiveRecord::Migration
  def change
    
    Question.get('primary_real_estate').update_attribute(:sub_questions, [
        {
            question_type: 'address', name: 'real_estate_address', position: 1, title: 'What is the address of your primary residence?'
        },
        {
            question_type: 'yesno', name: 'real_estate_jointly_owned', position: 2, title: 'Is your primary residence jointly owned?'
        },
        {
            question_type: 'percentage', name: 'real_estate_jointly_owned_percent', position: 3, title: 'What percentage of ownership do you have in your primary residence?'
        },
        {
            question_type: 'percentage', name: 'real_estate_percent_of_mortgage', position: 4, title: 'What percentage of the mortgage are you responsible for in your primary residence?'
        },
        {
            question_type: 'yesno', name: 'real_estate_name_on_mortgage', position: 5, title: 'Is your name on the mortgage?'
        },
        {
            question_type: 'currency', name: 'real_estate_value', position: 6, title: 'What is the current value of your primary residence?'
        },
        {
            question_type: 'currency', name: 'real_estate_mortgage_balance', position: 7, title: 'What is the mortgage balance on your primary residence?'
        },
        {
            question_type: 'yesno', name: 'real_estate_second_mortgage', position: 8, title: 'Is there a lien, 2nd mortgage or Home Equity Line of Credit on your primary residence?'
        },
        {
            question_type: 'yesno', name: 'real_estate_second_mortgage_your_name', position: 9, title: 'Is your name on the lien, 2nd mortgage or Home Equity Line of Credit against your primary residence?'
        },
        {
            question_type: 'percentage', name: 'real_estate_second_mortgage_percent', position: 10, title: 'What percentage of the lien, 2nd mortgage or Home Equity Line of Credit are you responsible for in your primary residence?'
        },
        {
            question_type: 'currency', name: 'real_estate_second_mortgage_value', position: 11, title: 'What is the current balance of the lien(s)?'
        },
        {
            question_type: 'yesno', name: 'real_estate_rent_income', position: 12, title: 'Do you receive income from your primary residence (rent, etc.)?'
        },
        {
            question_type: 'currency', name: 'real_estate_rent_income_value', position: 13, title: 'What is the income YOU receive from your primary residence (calculated annually)?'
        }
    ])

    Question.get('other_real_estate').update_attribute(:sub_questions, [
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
            question_type: 'yesno', name: 'real_estate_name_on_mortgage', position: 4, title: 'Is your name on the mortgage?'
        },
        {
            question_type: 'percentage', name: 'real_estate_percent_of_mortgage', position: 5, title: 'What percentage of the mortgage are you responsible for in your Other Real Estate?'
        },
        {
            question_type: 'currency', name: 'real_estate_value', position: 6, title: 'What is the current value of your Other Real Estate?'
        },
        {
            question_type: 'currency', name: 'real_estate_mortgage_balance', position: 7, title: 'What is the mortgage balance on your Other Real Estate?'
        },
        {
            question_type: 'yesno', name: 'real_estate_second_mortgage', position: 8, title: 'Is there a lien, 2nd mortgage or Home Equity Line of Credit on your Other Real Estate?'
        },
        {
            question_type: 'yesno', name: 'real_estate_second_mortgage_your_name', position: 9, title: 'Is your name on the lien, 2nd mortgage or Home Equity Line of Credit against your other real estate?'
        },
        {
            question_type: 'percentage', name: 'real_estate_second_mortgage_percent', position: 10, title: 'What percentage of the lien, 2nd mortgage or Home Equity Line of Credit are you responsible for in your other real estate?'
        },
        {
            question_type: 'currency', name: 'real_estate_second_mortgage_value', position: 11, title: 'What is the current balance of the lien(s)?'
        },
        {
            question_type: 'yesno', name: 'real_estate_rent_income', position: 12, title: 'Do you receive income from your Other Real Estate (rent, etc.)?'
        },
        {
            question_type: 'currency', name: 'real_estate_rent_income_value', position: 13, title: 'What is the income YOU receive from your Other Real Estate (calculated annually)?'
        }
    ])
  end
end
