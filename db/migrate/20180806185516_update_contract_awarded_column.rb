class UpdateContractAwardedColumn < ActiveRecord::Migration
  def change
    change_column :agency_requirements, :contract_awarded, :boolean, null: false, default: false
  end
end
