class CreateNewSbaSupervisorRole < ActiveRecord::Migration
  def change
    Role.create!(name: 'sba_supervisor')
  end
end
