class AddNewTags < ActiveRecord::Migration
  def change
    ["BOS", "Supervisor"].each do |name|
      Tag.create!(name: name)
    end
  end
end
