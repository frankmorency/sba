class UpdateMppSectionName < ActiveRecord::Migration
  def change
    Section.where({name: "size_redetermination"}).update_all(title: 'Redetermination of Size')
  end
end
