class CreateCurrentQuestionnaires < ActiveRecord::Migration
  def change
    create_table :current_questionnaires do |t|
      t.references :certificate_type, index: true, foreign_key: true
      t.references :questionnaire, index: true, foreign_key: true
      t.string :kind

      t.timestamps null: false
    end

    add_column  :sba_applications, :kind, :string
    add_column  :certificate_types, :renewal_notification_period_in_days, :integer

    Questionnaire.reset_column_information
    SbaApplication.reset_column_information
    CertificateType.reset_column_information

    SbaApplication.update_all kind: SbaApplication::INITIAL

    
    %w(wosb edwosb mpp eight_a).each do |cert_type|
      cert_type = CertificateType.get(cert_type)
      CurrentQuestionnaire.create!(questionnaire: cert_type.questionnaires.order(updated_at: :desc).where(initial_app: true, vendor_can_start: true).first, certificate_type: cert_type, kind: SbaApplication::INITIAL)
    end

    %w(wosb edwosb).each do |cert_type|
      cert_type = CertificateType.get(cert_type)
      CurrentQuestionnaire.create!(questionnaire: cert_type.questionnaires.order(updated_at: :desc).where(initial_app: true, vendor_can_start: true).first, certificate_type: cert_type, kind: SbaApplication::ANNUAL_REVIEW)
    end

    CertificateType.get('wosb').initial_questionnaire.update_attributes scheduler_can_start: true
    CertificateType.get('edwosb').initial_questionnaire.update_attributes scheduler_can_start: true

    CertificateType.get('wosb').update_attributes renewal_period_in_days: 365, renewal_notification_period_in_days: 45
    CertificateType.get('edwosb').update_attributes renewal_period_in_days: 365, renewal_notification_period_in_days: 45

  end
end
