class AssociateBusinessUnitsToProgram < ActiveRecord::Migration
  def change
    add_column  :business_units, :program_id, :integer
    add_column  :business_units, :title, :string

    
    BusinessUnit.reset_column_information

    eight_a = Program.find_by(name: 'eight_a')

    BusinessUnit.find_by(name: 'CODS').update_attributes(program_id: eight_a.id, title: 'CODS')
    BusinessUnit.find_by(name: 'DISTRICT_OFFICE').update_attributes(program_id: eight_a.id, title: 'District Office')
    BusinessUnit.find_by(name: 'AREA_OFFICE').update_attributes(program_id: eight_a.id, title: 'Area Office')
    BusinessUnit.find_by(name: 'HQ_LEGAL').update_attributes(program_id: eight_a.id, title: 'Legal')
    BusinessUnit.find_by(name: 'OIG').update_attributes(program_id: eight_a.id, title: 'Inspector General')
    BusinessUnit.find_by(name: 'HQ_PROGRAM').update_attributes(program_id: eight_a.id, title: 'HQ Program')

    BusinessUnit.find_by(name: 'WOSB').update_attributes(program_id: Program.find_by(name: 'wosb'), title: 'Woman Owned Small Business (WOSB)')
    BusinessUnit.find_by(name: 'MPP').update_attributes(program_id: Program.find_by(name: 'mpp'), title: 'Mentor Protégé Program (MPP)')
    BusinessUnit.find_by(name: 'HUBZONE').update_attributes(program_id: Program.find_by(name: 'wosb'), title: 'HUBZONE')

  end
end
