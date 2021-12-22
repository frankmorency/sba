class AddAdhocSubSectionReferenceToSection < ActiveRecord::Migration
  def change
    add_column :sections, :related_to_section_id, :integer # for adhoc questionnaires - they are related to other subsections in the application
    add_column :sba_applications, :adhoc_question_title, :text
    add_column :sba_applications, :adhoc_question_details, :text
  end
end
