class AddUserIdToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :user_id, :integer # add user id to the documents model to allow has_many relationship
    add_index :documents, :user_id
  end
end
