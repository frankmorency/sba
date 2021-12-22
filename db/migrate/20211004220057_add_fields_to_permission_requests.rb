class AddFieldsToPermissionRequests < ActiveRecord::Migration
  def change
    add_column :permission_requests, :action, :integer, default: 0
  end
end
