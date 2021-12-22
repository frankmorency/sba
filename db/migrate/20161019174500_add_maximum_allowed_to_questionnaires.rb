class AddMaximumAllowedToQuestionnaires < ActiveRecord::Migration
  def change
    add_column :questionnaires, :maximum_allowed, :integer, default: 1 # the maximum number of active questionnaires (of each type) that an organization is allowed
  end
end
