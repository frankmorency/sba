class RemoveBogusQuestionnaire < ActiveRecord::Migration
  def change
    
    Questionnaire.find_by(name: 'eight_a_company').destroy
    Section::SubApplication.destroy_all(name: 'eight_a_company')
  end
end
