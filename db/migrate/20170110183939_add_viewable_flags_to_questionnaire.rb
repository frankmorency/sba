class AddViewableFlagsToQuestionnaire < ActiveRecord::Migration
  def change
    add_column :questionnaires, :vendor_can_start, :boolean, default: true
    add_column :questionnaires, :analyst_can_start, :boolean, default: false
  end
end
