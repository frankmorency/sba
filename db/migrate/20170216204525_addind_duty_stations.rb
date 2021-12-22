class AddindDutyStations < ActiveRecord::Migration
  def change
    create_table :duty_stations do |t|
      t.string :facility_code
      t.string :street_address 
      t.string :city
      t.string :state 
      t.string :zip
      t.string :region_code
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end
  end
end
