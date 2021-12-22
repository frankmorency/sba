class UpdateBusinessUnits < ActiveRecord::Migration
  def change
        eight_a = Program.find_by(name: 'eight_a')

    BusinessUnit.find_by(name: 'HQ_LEGAL').update_attributes(title: 'OGC')
    BusinessUnit.find_by(name: 'OIG').update_attributes(title: 'Office of Inspector General')
    BusinessUnit.find_by(name: 'HQ_PROGRAM').update_attributes(title: 'Headquarters')

    BusinessUnit.create(name: 'HQ_AA', title: 'Associate Administrator', program_id: eight_a.id)
    BusinessUnit.create(name: 'SIZE', title: 'Size', program_id: eight_a.id)
  end
end
