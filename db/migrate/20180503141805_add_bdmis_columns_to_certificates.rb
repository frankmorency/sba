class AddBdmisColumnsToCertificates < ActiveRecord::Migration
  def change
    add_column :certificates, :suspended, :boolean, default: false
    add_column :certificates, :current_assigned_email, :text

    set_column_comment :certificates, :suspended, "Migrated from BDMIS to be used later"
    set_column_comment :certificates, :current_assigned_email, "Migrated from BDMIS to be used later for review assignment"
  end
end
