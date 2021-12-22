class FixAdhocQuestionnaireNames < ActiveRecord::Migration
  def change
    
    Questionnaire::SubQuestionnaire.find_by(name: 'adhoc_text_and_attachment').update_attribute(:title, 'Ad Hoc Text and Attachment Questionnaire')
    Questionnaire::SubQuestionnaire.find_by(name: 'adhoc_attachment').update_attribute(:title, 'Ad Hoc Attachment Questionnaire')
  end
end
