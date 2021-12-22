class RemoveUnused8ARolesFromDb < ActiveRecord::Migration
  def change
    role_names = %w(sba_supervisor_8a_district_office sba_supervisor_8a_area_office
sba_supervisor_8a_hq_legal sba_supervisor_8a_oig sba_supervisor_8a_hq_ce sba_analyst_8a_district_office sba_analyst_8a_area_office sba_analyst_8a_hq_aa sba_analyst_8a_hq_ce)

    Role.destroy_all name: role_names
  end
end
