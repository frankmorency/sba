class AddAaRoleBack < ActiveRecord::Migration
  def change
    
    unless Role.exists? name: 'sba_supervisor_8a_hq_aa'
      Role.create! name: 'sba_supervisor_8a_hq_aa'
    end
  end
end
