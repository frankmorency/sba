class AddBdmisCaseNumberToSbaApplications < ActiveRecord::Migration
  def change
    add_column :sba_applications, :bdmis_case_number, :string, default: nil
  end
end
