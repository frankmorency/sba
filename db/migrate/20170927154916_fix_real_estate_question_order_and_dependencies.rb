class FixRealEstateQuestionOrderAndDependencies < ActiveRecord::Migration
  def change
    
    Question.transaction do
      q = Question.find_by(name: 'primary_real_estate')
      json = q.read_attribute(:sub_questions)
      json[3]['position'] = 5
      json[4]['position'] = 4
      q.sub_questions = json
      q.save!
    end
  end
end
