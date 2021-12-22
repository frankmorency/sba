class UpdateUserAttributesForDevise < ActiveRecord::Migration
  def change
	change_table :users do |t|
	  t.remove :name, :password_digest, :last_login_at
	  t.text :first_name
	  t.text :last_name
	  t.text :phone_number
	end  	
  end
end
