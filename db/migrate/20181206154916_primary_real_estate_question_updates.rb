class PrimaryRealEstateQuestionUpdates < ActiveRecord::Migration
  def change
    Question.transaction do
      q = Question.find_by(name: 'primary_real_estate')
      json = [
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
            question_type: 'yesno', name: 'real_estate_second_mortgage', position: 8, title: 'Are there additional liens, second mortgages or Home Equity Lines of Credit on your primary residence?'
        },
        {
            question_type: 'currency', name: 'real_estate_second_mortgage_balance', position: 9, title: 'What is the total current balance of all lien(s), 2nd mortgages or Home Equity Lines of Credit on this property?'
        },
        {
            question_type: 'yesno', name: 'real_estate_second_mortgage_your_name', position: 10, title: 'Is your name on the lien, 2nd mortgage or Home Equity Line of Credit against your primary residence?'
        },
        {
            question_type: 'percentage', name: 'real_estate_second_mortgage_percent', position: 11, title: 'What percentage of the lien, 2nd mortgage or Home Equity Line of Credit are you responsible for in your primary residence?'
        },
        {
            question_type: 'currency', name: 'real_estate_second_mortgage_value', position: 12, title: 'What is the current balance of the lien(s)?'
        },
        {
            question_type: 'yesno', name: 'real_estate_rent_income', position: 13, title: 'Do you receive income from your primary residence (rent, etc.)?'
        },
        {
            question_type: 'currency', name: 'real_estate_rent_income_value', position: 14, title: 'What is the income YOU receive from your primary residence (calculated annually)?'
        }
      ]
      q.sub_questions = json
      q.save!
    end
  end
end
