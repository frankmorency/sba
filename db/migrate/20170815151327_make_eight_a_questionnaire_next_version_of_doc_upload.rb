class MakeEightAQuestionnaireNextVersionOfDocUpload < ActiveRecord::Migration
  def change
    
    CurrentQuestionnaire.reset_column_information

    eight_a = CertificateType.find_by(name: 'eight_a')

    eight_a.current_questionnaires.create! questionnaire: Questionnaire.find_by(name: 'eight_a_initial'), for_testing: true, kind: SbaApplication::INITIAL
    eight_a.questionnaire_histories.create! version: 2, kind: SbaApplication::INITIAL, questionnaire: Questionnaire.find_by(name: 'eight_a_initial')
  end
end
