class CreateOfficeRequests < ActiveRecord::Migration
  def change
    create_table :office_requests do |t|
      t.integer :duty_station_id, null: false
      t.integer :access_request_id, null: false
      t.datetime :deleted_at
      t.timestamps    
    end
  end
end
