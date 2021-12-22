class AddDurationToVoluntarySuspension < ActiveRecord::Migration
  def change
    add_column :voluntary_suspensions, :suspension_duration_months, :integer
  end
end
