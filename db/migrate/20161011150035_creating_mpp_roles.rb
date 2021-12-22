class CreatingMppRoles < ActiveRecord::Migration
  def change
    Role.create!(name: 'mpp_sba_supervisor')
    Role.create!(name: 'mpp_sba_analyst')
  end
end
