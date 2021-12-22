class MakeApplicationsBelongToCertificates < ActiveRecord::Migration
  def change
    add_column :sba_applications, :certificate_id, :integer

    # roll back to earlier version and create actual data to test
    # save the database
    # migrate up
    # test
    # rollback database -> go back to beginning

    SbaApplication.reset_column_information

    Certificate.all.each do |cert|
      cert.sba_application.update_attribute(:certificate_id, cert.id)
    end

    remove_column :certificates, :sba_application_id
  end
end
