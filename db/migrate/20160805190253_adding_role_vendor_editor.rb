class AddingRoleVendorEditor < ActiveRecord::Migration
  def change
    Role.create!(name: 'vendor_editor')
  end
end
