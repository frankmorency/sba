class ChangeNameOfPotentialForSuccessQuestionnaire < ActiveRecord::Migration
  def change
    
    Questionnaire.find_by(name: 'eight_a_potential_for_success').update_attribute(:title, 'Potential for Success')
  end
end
