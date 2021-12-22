class AddingAdditionalEightARoles < ActiveRecord::Migration
  def change

    list = %w(sba_analyst_8a_cods 
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
              sba_supervisor_8a_hq_ce)

    list.each do |name|
      Role.create!(name: name)
    end

  end
end
