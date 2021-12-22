class UpdateDutyStation < ActiveRecord::Migration
  def change
    DutyStation.find_by_name('Washington').update_column(:name, 'Washington D.C.')
  end
end
