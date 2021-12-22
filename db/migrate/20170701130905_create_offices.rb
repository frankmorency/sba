class CreateOffices < ActiveRecord::Migration
  def change
    create_table :offices do |t|
      t.integer :duty_station_id, null: false
      t.integer :user_id, null: false
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
