class CreateOfficeLocations < ActiveRecord::Migration
  def change
    create_table :office_locations do |t|
      t.integer :business_unit_id, null: false
      t.integer :user_id, null: false
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
