class AddNewBusinessUnit < ActiveRecord::Migration
  def change
        eight_a = Program.find_by(name: 'eight_a')
    BusinessUnit.create(name: 'OPS', title: 'OPS', program_id: eight_a.id)
  end
end
