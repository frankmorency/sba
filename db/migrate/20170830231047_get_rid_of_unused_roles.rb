class GetRidOfUnusedRoles < ActiveRecord::Migration
  def change
    ["DO", "OFFICE", "AREA", "OFFICE", "OGC", "HQ", "HQ_CE", "HQ_Legal", "HQ_AA"].each do |name|
      BusinessUnit.find_by(name: name).try(:destroy)
    end

    %w(
      sba_analyst_8a_district_office
      sba_analyst_8a_area_office
      sba_analyst_8a_hq_legal
      sba_analyst_8a_oig
      sba_analyst_8a_hq_program
      sba_analyst_8a_hq_aa
      sba_analyst_8a_hq_ce
      sba_supervisor_8a_cods
      sba_supervisor_8a_district_office
      sba_supervisor_8a_area_office
      sba_supervisor_8a_hq_legal
      sba_supervisor_8a_oig
      sba_supervisor_8a_hq_program
      sba_supervisor_8a_hq_aa
      sba_supervisor_8a_hq_ce
    ).each do |role|
      Role.find_by(name: role).try(:destroy)
    end
  end
end
