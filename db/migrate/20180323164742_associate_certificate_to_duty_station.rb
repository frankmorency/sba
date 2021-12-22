class AssociateCertificateToDutyStation < ActiveRecord::Migration
  def change
    add_column :certificates, :duty_station_id, :integer
  end
end
