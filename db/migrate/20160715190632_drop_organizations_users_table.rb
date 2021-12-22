class DropOrganizationsUsersTable < ActiveRecord::Migration
  def change
    drop_table :organizations_users do |t|
      t.integer :organization_id, null: false
      t.integer :user_id, null: false
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
