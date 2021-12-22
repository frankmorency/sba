class PotentialForSuccessCopyUpdate < ActiveRecord::Migration
  def change
    
    # Potential for success
    s16 = Question.find_by(name: 'eight_a_pos_revenue_a')
    s16.title = "Are you applying for the 8(a) program under the same primary NAICS code listed for your firm in SAM.gov?"
    s16.save!
  end
end
