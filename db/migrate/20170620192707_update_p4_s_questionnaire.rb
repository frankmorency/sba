class UpdateP4SQuestionnaire < ActiveRecord::Migration
  def change
    
    Section.where(questionnaire_id: Questionnaire.get('eight_a_potential_for_success').id, name: 'review').update_all is_last: true
  end
end
