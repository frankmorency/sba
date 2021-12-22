class CreateVersionsIfNotExists < ActiveRecord::Migration

  # The largest text column available in all supported RDBMS is
  # 1024^3 - 1 bytes, roughly one gibibyte.  We specify a size
  # so that MySQL will use `longtext` instead of `text`.  Otherwise,
  # when serializing very large objects, `text` might not be big enough.
  TEXT_BYTES = 1_073_741_823

  def change
    return if Rails.env.production?
    return if table_exists?(:versions)

    # conn = ActiveRecord::Base.connection
    # conn.schema_search_path = 'audit'

    create_table :versions do |t|
      t.text :item_type, :null => false
      t.integer :item_id, :null => false
      t.text :event, :null => false
      t.text :whodunnit
      t.jsonb :object
      t.jsonb :object_changes
      t.datetime :created_at
    end
  end
end
