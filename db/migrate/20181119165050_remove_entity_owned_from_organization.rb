class RemoveEntityOwnedFromOrganization < ActiveRecord::Migration
  def change
    remove_column :organizations, :entity_owned
  end
end
