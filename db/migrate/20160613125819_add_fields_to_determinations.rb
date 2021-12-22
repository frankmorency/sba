class AddFieldsToDeterminations < ActiveRecord::Migration
  def change
    # there are multiple determination outcomes, all of which are still considered "eligible" - this flag makes it more obvious which are which
    add_column :determinations, :eligible, :boolean
  end
end
