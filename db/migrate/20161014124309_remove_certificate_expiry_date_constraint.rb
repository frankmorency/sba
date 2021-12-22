class RemoveCertificateExpiryDateConstraint < ActiveRecord::Migration
  def change
    change_column :certificates, :expiry_date, :datetime, :null => true
    Certificate.reset_column_information
  end
end
