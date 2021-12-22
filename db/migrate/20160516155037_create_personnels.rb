class CreatePersonnels < ActiveRecord::Migration
  
  def up
    ActiveRecord::Base.connection.execute("select * into personnels from organizations_users")
    ActiveRecord::Base.connection.execute("ALTER TABLE personnels ADD id SERIAL;")
    ActiveRecord::Base.connection.execute("ALTER TABLE personnels ADD PRIMARY KEY (id);")

    # # finally, dump the old hatbm associations
    # drop_table :organizations_users
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end