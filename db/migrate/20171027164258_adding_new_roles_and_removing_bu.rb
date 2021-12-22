class AddingNewRolesAndRemovingBu < ActiveRecord::Migration
  def change

    BusinessUnit.find_by(name: "AREA_OFFICE").delete
    %w(sba_analyst_8a_size sba_supervisor_8a_size sba_analyst_8a_ops sba_supervisor_8a_ops).each do |name|
      Role.create!(name: name)
    end

    %w(sba_supervisor_8a_area_office sba_analyst_8a_area_office).each do |name|
      r = Role.find_by(name: name).delete
    end

  end
end