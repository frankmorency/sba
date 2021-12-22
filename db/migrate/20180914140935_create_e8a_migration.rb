class CreateE8aMigration < ActiveRecord::Migration
  def change
    create_table :e8a_migrations do |t|
      t.text :unique_number, index: true, comment: 'AgencyRequirement.unique number, RqmtLtrTbl.RqmtNmb in e8a'
      t.text :error_messages
      t.jsonb :fields
      t.timestamps null: false
    end
  end
end
