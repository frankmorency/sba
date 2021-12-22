class AddPrerequisiteOrderToSbaApplications < ActiveRecord::Migration
  def change
    add_column :questionnaires, :prerequisite_order, :integer
    add_column :sba_applications, :prerequisite_order, :integer
  end
end
