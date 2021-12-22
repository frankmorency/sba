class UpdateOpsSupportRole < ActiveRecord::Migration
  def change
    return if %w( build build_admin).include? Rails.env
    role = Role.find_by_name("sba_ops_support")
    role.name = "sba_ops_support_staff"
    role.save!
    Role.create!(name: 'sba_ops_support_admin')
  end
end
