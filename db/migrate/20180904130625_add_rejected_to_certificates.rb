class AddRejectedToCertificates < ActiveRecord::Migration
  def change
    add_column :certificates, :rejected, :boolean, default: false
    set_column_comment :certificates, :rejected, "Last recommendation from BDMIS to be used later"
  end
end
