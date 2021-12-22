class CreateContributor < ActiveRecord::Migration
  def change
    create_table :contributors do |t|
      t.string :full_name
      t.string :email 
      t.references :section
      t.references :sba_application
      t.integer :position
      t.string :section_name_type
      t.datetime :expires_at
      t.timestamps null: false
      t.datetime :deleted_at
    end
  end
end
