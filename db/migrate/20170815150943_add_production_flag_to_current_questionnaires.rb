class AddProductionFlagToCurrentQuestionnaires < ActiveRecord::Migration
  def change
    add_column  :current_questionnaires, :for_testing, :boolean, default: false # this allows new questionnaires to be tested locally and in lower environments before being available in prod
  end
end
