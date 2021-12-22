class AddNewColumnsToBdmis < ActiveRecord::Migration
  def change
    add_column :bdmis_migrations, :current_assigned_email, :text
    add_column :bdmis_migrations, :last_recommendation, :text

    set_column_comment :bdmis_migrations, :current_assigned_email, "New columns from the BDMIS csv import"
    set_column_comment :bdmis_migrations, :last_recommendation, "New columns from the BDMIS csv import"
  end
end
