class Make8AEligibilityRequiredFirst < ActiveRecord::Migration
  def change
    
    Questionnaire::SubQuestionnaire.reset_column_information
    SbaApplication::SubApplication.reset_column_information

    q = Questionnaire::SubQuestionnaire.find_by(name: 'eight_a_eligibility')
    q.update_attributes!(prerequisite_order: 0)
    raise "WHY WHY WHY" if Questionnaire::SubQuestionnaire.find_by(prerequisite_order: 0).nil?
    q.sba_applications.each do |app|
      app.update_attributes!(prerequisite_order: 0)
    end
  end
end
