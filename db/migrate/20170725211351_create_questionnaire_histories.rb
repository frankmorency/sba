class CreateQuestionnaireHistories < ActiveRecord::Migration
  def change
    create_table :questionnaire_histories do |t|
      t.references :certificate_type, index: true, foreign_key: true
      t.references :questionnaire, index: true, foreign_key: true
      t.string  :kind
      t.integer :version

      t.timestamps null: false
    end

    
    wosb = CertificateType.find_by(name: 'wosb')
    edwosb = CertificateType.find_by(name: 'edwosb')
    eight_a = CertificateType.find_by(name: 'eight_a')
    mpp = CertificateType.find_by(name: 'mpp')

    edwosb.questionnaire_histories.create! version: 1, kind: SbaApplication::INITIAL, questionnaire: Questionnaire.find_by(name: 'edwosb_v_one')
    edwosb.questionnaire_histories.create! version: 2, kind: SbaApplication::INITIAL, questionnaire: Questionnaire.find_by(name: 'edwosb_v_two')
    edwosb.questionnaire_histories.create! version: 3, kind: SbaApplication::INITIAL, questionnaire: Questionnaire.find_by(name: 'edwosb_v_three')
    edwosb.questionnaire_histories.create! version: 4, kind: SbaApplication::INITIAL, questionnaire: Questionnaire.find_by(name: 'edwosb')

    edwosb.questionnaire_histories.create! version: 1, kind: SbaApplication::ANNUAL_REVIEW, questionnaire: Questionnaire.find_by(name: 'edwosb_v_one')
    edwosb.questionnaire_histories.create! version: 2, kind: SbaApplication::ANNUAL_REVIEW, questionnaire: Questionnaire.find_by(name: 'edwosb_v_two')
    edwosb.questionnaire_histories.create! version: 3, kind: SbaApplication::ANNUAL_REVIEW, questionnaire: Questionnaire.find_by(name: 'edwosb_v_three')
    edwosb.questionnaire_histories.create! version: 4, kind: SbaApplication::ANNUAL_REVIEW, questionnaire: Questionnaire.find_by(name: 'edwosb')

    wosb.questionnaire_histories.create! version: 1, kind: SbaApplication::INITIAL, questionnaire: Questionnaire.find_by(name: 'wosb_v_one')
    wosb.questionnaire_histories.create! version: 2, kind: SbaApplication::INITIAL, questionnaire: Questionnaire.find_by(name: 'wosb')

    wosb.questionnaire_histories.create! version: 1, kind: SbaApplication::ANNUAL_REVIEW, questionnaire: Questionnaire.find_by(name: 'wosb_v_one')
    wosb.questionnaire_histories.create! version: 2, kind: SbaApplication::ANNUAL_REVIEW, questionnaire: Questionnaire.find_by(name: 'wosb')

    mpp.questionnaire_histories.create! version: 1, kind: SbaApplication::INITIAL, questionnaire: Questionnaire.find_by(name: 'mpp')
    mpp.questionnaire_histories.create! version: 1, kind: SbaApplication::ANNUAL_REVIEW, questionnaire: Questionnaire.find_by(name: 'mpp_annual_renewal')

    eight_a.questionnaire_histories.create! version: 1, kind: SbaApplication::INITIAL, questionnaire: Questionnaire.find_by(name: 'eight_a')
  end
end
