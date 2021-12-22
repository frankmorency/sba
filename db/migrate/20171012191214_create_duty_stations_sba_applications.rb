class CreateDutyStationsSbaApplications < ActiveRecord::Migration
  def change
    create_table :duty_stations_sba_applications do |t|
      t.references :sba_application
      t.references :duty_station
    end
  end
end
