class AddProcessFieldsToVoluntarySuspensions < ActiveRecord::Migration
  def change
    add_column :voluntary_suspensions, :extended_at, :timestamp
    add_column :voluntary_suspensions, :extended_by_id, :integer
    add_foreign_key :voluntary_suspensions, :users, column: :extended_by_id

    add_column :voluntary_suspensions, :denied_at, :timestamp
    add_column :voluntary_suspensions, :denied_by_id, :integer
    add_foreign_key :voluntary_suspensions, :users, column: :denied_by_id
  end
end