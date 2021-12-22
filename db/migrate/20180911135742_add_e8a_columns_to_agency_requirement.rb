class AddE8aColumnsToAgencyRequirement < ActiveRecord::Migration
  def change
    add_column :agency_requirements, :case_number, :string
    add_column :agency_requirements, :e8a_created_at, :datetime
    add_column :agency_requirements, :e8a_deleted_at, :datetime
  end
end
