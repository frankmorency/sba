class De192AmIEligibleFix2 < ActiveRecord::Migration
  def change
    
    q1 = Question.find_by(name: 'eighta_one_time_used')
    q1.update_attribute('title', 'Have any individual(s) claiming social and economic disadvantage previously used their one time 8(a) eligibility to qualify a business for the 8(a) BD Program?')
    q1.save!

    q2 = Question.find_by(name: 'address_in_hubzone')
    q2.update_attribute('title', 'Is the address of the location where the majority of the firm’s employees work located in a HUBZone?')
    q2.save!
  end
end
