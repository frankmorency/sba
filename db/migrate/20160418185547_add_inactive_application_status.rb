class AddInactiveApplicationStatus < ActiveRecord::Migration
  def change
    
    ApplicationStatusType.create! name: 'Inactive', description: 'Inactive - like after someone returns to vendor'
  end
end
