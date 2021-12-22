class AddBizProgramToUsers < ActiveRecord::Migration
  def change
    add_column :users, :roles_map, :json  # this is the user hash where the roles will be saved
    add_column :access_requests, :roles_map, :json # this is the user hash where the roles will be saved

    # execute('CREATE  INDEX  "index_users_on_roles_map" ON "users" USING gin ("roles_map");')
  end

end
