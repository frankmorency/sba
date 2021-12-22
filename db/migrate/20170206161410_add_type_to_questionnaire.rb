class AddTypeToQuestionnaire < ActiveRecord::Migration
  def change
    add_column :questionnaires, :type, :string    # for subclassing questionnaires
    add_column :sba_applications, :type, :string  # for subclassing applications
    add_column :sections, :sub_questionnaire_id, :integer # for master questionnaires to have sub questionnaires
    add_column :sections, :sub_application_id, :integer # for master applications to have sub applicationss

    Questionnaire.reset_column_information
    SbaApplication.reset_column_information
    Section.reset_column_information

    Questionnaire.update_all type: 'Questionnaire::SimpleQuestionnaire'
    SbaApplication.update_all type: 'SbaApplication::SimpleApplication'
  end
end
