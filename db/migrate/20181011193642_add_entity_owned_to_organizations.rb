class AddEntityOwnedToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :entity_owned, :boolean
  end
end
