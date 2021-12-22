class CreateAdditionalRoles < ActiveRecord::Migration
  def change
    Role.create!(name: "contributor")
  end
end
