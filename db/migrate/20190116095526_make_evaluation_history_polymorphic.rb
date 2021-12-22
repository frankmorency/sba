class MakeEvaluationHistoryPolymorphic < ActiveRecord::Migration
  def change
    rename_column :evaluation_histories, :evaluation_type, :category
    rename_column :evaluation_histories, :evaluation_value, :value
    rename_column :evaluation_histories, :evaluation_stage, :stage

    add_column :evaluation_histories, :evaluable_type, :string, comment: 'The type of model that is being evaluated'
    rename_column :evaluation_histories, :sba_application_id, :evaluable_id

    EvaluationHistory.reset_column_information
    EvaluationHistory.update_all(evaluable_type: 'SbaApplication')

    add_index :evaluation_histories, :evaluator_id
    add_index :evaluation_histories, [:evaluable_id, :evaluable_type]
  end
end