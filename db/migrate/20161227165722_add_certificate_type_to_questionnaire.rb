class AddCertificateTypeToQuestionnaire < ActiveRecord::Migration
  def change
    add_column :questionnaires, :certificate_type_id, :integer  # support for multiple questionnaires per cert type
    add_column :questionnaires, :initial_app, :boolean # is this questionnaire used as the "initial application" vendors fill out (with future support for multiple simultaneous)
    add_column :sba_applications, :questionnaire_id, :integer # each app needs to associate directly to a questionnaire instead of a cert type
#    change_column :sba_applications, :certificate_type_id, :integer, :null => true  # these indexes only exist in prod?

    Questionnaire.reset_column_information
    SbaApplication.reset_column_information

    CertificateType.all.each do |cert_type|
      q = Questionnaire.find_by(id: cert_type.questionnaire_id)
      q.update_attributes(certificate_type_id: cert_type.id, initial_app: true) if q
      cert_type.sba_applications.update_all(questionnaire_id: cert_type.questionnaire_id)
    end

#    remove_index :sba_applications, name: 'UK_application' # these indexes only exist in prod?
    remove_column :certificate_types, :questionnaire_id # support for multiple questionnaires per cert type
    remove_column :sba_applications, :certificate_type_id # each app needs to associate directly to a questionnaire instead of a cert type

    add_index "sba_applications", ["questionnaire_id", "organization_id", "application_start_date", "deleted_at"], name: "UK_sba_application", unique: true, using: :btree
  end
end
