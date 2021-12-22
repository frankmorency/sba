class AddFlagsToQuestionnaire < ActiveRecord::Migration
  def change
    add_column :questionnaires, :scheduler_can_start, :boolean, default: false

      end
end
