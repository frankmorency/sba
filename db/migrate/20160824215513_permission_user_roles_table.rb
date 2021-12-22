class PermissionUserRolesTable < ActiveRecord::Migration
  def change
    if %w(dev qa demo_admin stage_admin production_admin).include? Rails.env
      execute <<-SQL
        GRANT DELETE ON TABLE sbaone.users_roles TO rl_write;
      SQL
    end
  end
end
