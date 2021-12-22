class RenameAdminRole < ActiveRecord::Migration
  def up
    r = Role.find_by_name("admin")
    unless r.nil?
      r.name = "certify_system_admin"
      r.save!
    end
  end

  def down
    r = Role.find_by_name("certify_system_admin")
    unless r.nil?
      r.name = "admin"
      r.save!
    end
  end
end
