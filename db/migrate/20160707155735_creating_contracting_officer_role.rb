class CreatingContractingOfficerRole < ActiveRecord::Migration
  def change
    Role.create!(name: 'federal_contracting_officer')
  end
end
