class AllowNullUserInAgencyRequirement < ActiveRecord::Migration
  def change
    change_column :agency_requirements, :user_id, :integer, :null => true
  end
end
