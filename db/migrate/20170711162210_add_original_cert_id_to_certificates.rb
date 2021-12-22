class AddOriginalCertIdToCertificates < ActiveRecord::Migration
  def change
    # THIS COLUMN IS NEEDED IN THE INTERIM TO TIE ANNUAL RENEWAL (ANNUAL REPORT) CERTS
    # TO THE ORIGINAL CERTIFICATE THAT WAS CREATED FOR THEM - So for MPP we know which
    # annual reports go with which initial application
    add_column :certificates, :original_certificate_id, :integer
    add_column :sba_applications, :original_certificate_id, :integer
  end
end
