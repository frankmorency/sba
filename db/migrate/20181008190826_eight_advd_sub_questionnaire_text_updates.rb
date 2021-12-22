class EightAdvdSubQuestionnaireTextUpdates < ActiveRecord::Migration
  def change
    Question.find_by(name: 'criminal_history_q3').update_attribute(:title, 'For any criminal offense – other than a minor vehicle violation – have you ever: <ul><li>Been convicted</li><li>Pleaded guilty</li><li>Pleaded nolo contendere</li><li>Been placed on pretrial diversion</li><li>Been placed on any form of parole or probation (including probation before judgment)</li></ul>')

    Question.find_by(name: 'criminal_history_doc_q0').update_attribute(:title, 'Upload a narrative for each arrest, conviction, or incident involving formal criminal charges brought against you.')

    Question.transaction do
      index = nil
      q = Question.find_by(name: 'primary_real_estate')
      json = q.read_attribute(:sub_questions)
      json.each_with_index do |subq, i|
        if subq['name'] == 'real_estate_percent_of_mortgage'
          index = i
        end
      end
      json[index]['title'] = 'What percentage of the mortgage are you responsible for in your primary residence, as shown in legal documents?'
      q.sub_questions = json
      q.save!
    end
  end
end
