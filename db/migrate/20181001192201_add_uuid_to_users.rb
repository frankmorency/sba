class AddUuidToUsers < ActiveRecord::Migration
  def change
    # TODO enable this once we figure how to install extensions in AWS Postgres
    # enable_extension "pgcrypto"
    add_column :users, :uuid, :uuid #, default: 'gen_random_uuid()' TODO uncomment this
  end
end
