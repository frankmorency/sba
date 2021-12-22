class AddColumnRoleIdToAccessRequests < ActiveRecord::Migration
  def change
    add_column :access_requests, :role_id, :integer
  end
end
