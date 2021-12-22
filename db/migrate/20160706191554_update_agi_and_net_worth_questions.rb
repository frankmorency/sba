class UpdateAgiAndNetWorthQuestions < ActiveRecord::Migration
  def change
    
    q1 = Question.find_by(name: 'agi_3_year_exceeds_but_uncommon')
    q1.update_attribute('title', 'The adjusted gross income of the woman claiming economic disadvantage averaged over the three years preceding the certification exceeds $350,000; however, the woman can show that this income level was unusual and not likely to occur in the future, that losses commensurate with and directly related to the earnings were suffered, or that the income is not indicative of lack of economic disadvantage.')
    q1.save!

    q2 = Question.find_by(name: 'agi_3_year_less_than_350k')
    q2.update_attribute('title', 'The adjusted gross income of the woman claiming economic disadvantage averaged over the three years preceding the certification does not exceed $350,000.')
    q2.save!

    q3 = Question.find_by(name: 'demonstrate_less_than_750k')
    q3.update_attribute('title', 'The economically disadvantaged woman upon whom eligibility is based has read the SBA\'s regulations defining economic disadvantage and can demonstrate that her personal net worth is less than $750,000, excluding her ownership interest in the concern and her equity interest in her primary personal residence.')
    q3.save!

  end
end
