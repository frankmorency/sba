class AddNew8aRoles < ActiveRecord::Migration
  def change
    Role.create!(name: 'sba_analyst_8a')
    Role.create!(name: 'sba_supervisor_8a')
  end
end
