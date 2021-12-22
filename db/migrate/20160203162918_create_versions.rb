class CreateVersions < ActiveRecord::Migration

  # The largest text column available in all supported RDBMS.
  # See `create_versions.rb` for details.
  TEXT_BYTES = 1_073_741_823

  def change
    conn = ActiveRecord::Base.connection
    old_schema_search_path = conn.schema_search_path
    conn.schema_search_path = 'audit'

    create_table :versions do |t|
      t.text     :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.text     :event,     :null => false
      t.text     :whodunnit
      t.jsonb    :object
      t.jsonb    :object_changes
      t.datetime :created_at
    end
    add_index :versions, [:item_type, :item_id]

    conn.schema_search_path = old_schema_search_path

  end
end
