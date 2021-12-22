class AddTagsToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :tags, :json # these are tags that are associated with a document uploaded by an analyst
  end
end
