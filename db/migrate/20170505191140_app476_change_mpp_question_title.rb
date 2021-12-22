class App476ChangeMppQuestionTitle < ActiveRecord::Migration
  def change
        Questionnaire.get("mpp").sections.find_by(name: 'trade_education').update_attribute(:title, 'Intl Trade Education Needs')
  end
end
