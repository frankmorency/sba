class QuestionnaireHistoryBdmisArchive < ActiveRecord::Migration
  def change
    # Adding this will prevent creation of an 8(a) Initial Questionnaire when a firm has BDMIS Archive
    eight_a = CertificateType.find_by(name: 'eight_a')
    eight_a.questionnaire_histories.create! version: -1, kind: SbaApplication::INITIAL, questionnaire: Questionnaire.find_by(name: 'bdmis_archive')

  end
end
