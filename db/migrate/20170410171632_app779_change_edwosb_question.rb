class App779ChangeEdwosbQuestion < ActiveRecord::Migration
  def change
    
    q = Question.find_by(name: 'automobiles')
    q.update_attribute('title', 'Do you own any vehicles?')
    q.save!
    q = Question.find_by(name: 'notes_payable')
    q.update_attribute('title', 'Do you have any notes payable or other liabilities?')
    q.save!



  end
end
