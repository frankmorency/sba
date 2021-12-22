class AgencyRequirementDocument < ActiveRecord::Migration
  def change
    create_table :agency_requirement_documents  do |t|
      t.column :user_id, :integer
      t.column :agency_requirement_id, :integer
      t.column :stored_file_name, :text, comment: "Name of the file assigned during legacy migration."
      t.column :original_file_name, :text, comment: "Name of the file displayed to the user."
      t.column :document_type, :text, comment: "Chosen from AgencyRequirementDocument::AGENCY_DOCUMENT_TYPES."
      t.column :file_metadata, :json, comment: "Many data types and their relationships."
      t.column :updated_at, :datetime, comment: "Date and time the record was last updated. "
      t.column :comment, :text, comment: "Holds an comments user entered for the document."
      t.column :is_active, :boolean, default: false, comment: "A boolen indicating if the user is active."
      t.column :av_status, :text, comment: "Indicates the Anti Virus Scan status of the uploaded document."
      t.column :valid_pdf, :boolean, comment: "Indicates if the PDF validation succeeded."
      t.column :user_id, :integer, comment: "Associate a document to the user that created/uploaded it"
      t.column :compressed_status, :string, default: "ready", comment: "TBD"
      t.column :deleted_at, :datetime, index: true
      t.timestamps null: false
    end
  end
end
