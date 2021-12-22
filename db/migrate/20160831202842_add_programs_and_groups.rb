class AddProgramsAndGroups < ActiveRecord::Migration
  def change
    
    program = Program.create!(name: 'wosb', title: 'Women-Owned Small Business')
    Group.create!(name: 'wosb', title: 'Women-Owned Small Business', program: program)
    program = Program.create!(name: 'mpp', title: 'Mentor Protégé')
    Group.create!(name: 'mpp', title: 'Mentor Protégé', program: program)
  end
end
