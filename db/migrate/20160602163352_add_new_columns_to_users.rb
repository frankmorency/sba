class AddNewColumnsToUsers < ActiveRecord::Migration
  def change
      # All those feilds are user information send by MAX (idp) to US when a user logs in.
      add_column :users, :max_user_classification, :string      # MAX clasification ( federal or contractor )
      add_column :users, :max_agency, :string                   # User's agency within MAX ( Small Buisness Adminstration )
      add_column :users, :max_org_tag, :string                  # User's agency tag name (abreviation ex SBA) in MAX
      add_column :users, :max_group_list, :string               # User's groups within MAX
      add_column :users, :max_id, :string                       # User's MAX ID which is *-> Max primary key <-*
      add_column :users, :max_first_name, :string               # User's first name in MAX
      add_column :users, :max_security_level_list, :string      # User's security level in MAX
      add_column :users, :max_last_name, :string                # User's last name in MAX
      add_column :users, :max_email, :string                    # User's email in MAX
      add_column :users, :max_bureau, :string                   # User's bureau within an orgainzation saved in MAX
  end
end
