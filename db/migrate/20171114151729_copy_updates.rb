class CopyUpdates < ActiveRecord::Migration
  def change
    
    # Am I Eligible
    s16 = Question.find_by(title: 'Does the firm have a place of business in the U.S. and operate primarily within the United States, or makes a significant contribution to the U.S. economy through payment of taxes or use of American products, materials or labors?')
    s16.title = "Does the firm have a place of business in the U.S. and operate primarily within the United States, or make a significant contribution to the U.S. economy through payment of taxes or use of American products, materials or labors?"
    s16.save!

    # 8a - Criminal History - Documentation
    s15 = Question.find_by(name: 'criminal_history_doc_q0')
    s15.title = "Upload a narrative for each arrest, conviction, or incident involving formal criminal charges brought against you."
    s15.save!

    # 8a - Character
    s17 = Question.find_by(name: 'character_16b')
    s17.title = "Does the applicant firm have any outstanding delinquent federal, state or local financial obligations or liens filed against it?"
    s17.save!

    # 8a - POS - Revenue
    s18 = Question.find_by(name: 'eight_a_pos_revenue_a')
    s18.title = "Is the NAICS code for which the applicant firm is applying to the 8(a) Business Development Program the same as the applicant firm’s primary NAICS code listed in SAM.gov?"
    s18.save!

    # 8a - DVD - Citizenship
    s19 = Question.find_by(name: 'eight_a_us_citizenship')
    s19.title = "Are you a U.S. Citizen?"
    s19.save!

  end
end
