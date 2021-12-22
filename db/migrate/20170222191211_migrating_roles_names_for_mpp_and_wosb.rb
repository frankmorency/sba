class MigratingRolesNamesForMppAndWosb < ActiveRecord::Migration
  def up
    r = Role.find_by_name("sba_owner")
    unless r.nil?
      r.name = "sba_analyst_wosb"
      r.save!
    end

    r = Role.find_by_name("sba_supervisor")
    unless r.nil?
      r.name = "sba_supervisor_wosb"
      r.save!
    end

    r = Role.find_by_name("mpp_sba_supervisor")
    unless r.nil?
      r.name = "sba_supervisor_mpp"
      r.save!
    end

    r = Role.find_by_name("mpp_sba_analyst")
    unless r.nil?
      r.name = "sba_analyst_mpp"
      r.save!
    end
  end

  def down
  end
end
