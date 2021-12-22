class RemoveCertificateIssueDateConstraint < ActiveRecord::Migration
  def change
    change_column :certificates, :issue_date, :datetime, :null => true
    Certificate.reset_column_information
  end
end
