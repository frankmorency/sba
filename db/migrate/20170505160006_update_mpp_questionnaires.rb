class UpdateMppQuestionnaires < ActiveRecord::Migration
  def change
    
    q = Question.find_by(name: 'mpp_providing_trade_ed')
    q.update_attribute('title', 'Will the Mentor be providing the Protégé with “International Trade Education” assistance?')
    q.save!

  end
end
