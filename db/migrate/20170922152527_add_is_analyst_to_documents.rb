class AddIsAnalystToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :is_analyst, :boolean, default: false # indicates if the document was uploaded by an analyst
  end
end
