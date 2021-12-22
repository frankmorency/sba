class AddServicingBosToCertificate < ActiveRecord::Migration
  def change
    add_column :certificates, :servicing_bos_id, :integer # the user id of the person who serves as the servicing BOS
    Certificate.reset_column_information
    set_column_comment :certificates, :servicing_bos_id, "the user id of the person who serves as the servicing BOS"
  end
end
