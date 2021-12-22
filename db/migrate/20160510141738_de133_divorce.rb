class De133Divorce < ActiveRecord::Migration
  def change
    
    q = Question.find_by(name: 'owner_divorced')
    q.update_attribute('title', 'Is anyone listed above legally separated? If yes, please provide separation documents.')
    q.save!
  end
end
