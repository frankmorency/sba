class AddGroupsToExistingThings < ActiveRecord::Migration
  def change
    
    Questionnaire.get('wosb').update_attribute(:program_id, Program.find_by(name: 'wosb').id)
    Questionnaire.get('edwosb').update_attribute(:program_id, Program.find_by(name: 'wosb').id)
  end
end
