class CreatePermissionRequests < ActiveRecord::Migration
  def change
    create_table :permission_requests do |t|
      t.integer :access_request_id, null: false
      t.integer :user_id, null: false
      t.datetime :deleted_at
      t.timestamps
    end

    add_column :business_units, :deleted_at, :datetime

  end
end
