class CreateExpirationDates < ActiveRecord::Migration
  def change
    # The expiration_dates table will be used to change expiration dates for access requests - and maybe other things in the future
    create_table :expiration_dates do |t|
      t.text      :type   # Don't think this is used - can be removed
      t.text      :model  # Name of the other table whose expiration dates we're messing with
      t.text      :field  # Name of the specific field in the other table
      t.text      :days_from_now  # The actual number of days for this expiration
      t.timestamps null: false
    end
  end
end
