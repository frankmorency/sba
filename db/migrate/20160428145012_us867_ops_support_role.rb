class Us867OpsSupportRole < ActiveRecord::Migration
  def change
    Role.create!(name: 'ops_support')
  end
end