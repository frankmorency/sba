class AddZipFileAvailableToSbaApplication < ActiveRecord::Migration
  def change
    add_column :sba_applications, :zip_file_status, :integer, default: 0 # Status of Zip file of all documents. 0 - Not Created, 1 - Pending, 2 - Ready. Refer story APP-473
  end
end
