class CreateEvaluationHistory < ActiveRecord::Migration
  def change
    create_table :evaluation_histories do |t|
      t.string  :evaluation_type, null: false
      t.string  :evaluation_value, null: false
      t.string  :evaluation_stage, null: false
      t.references :sba_application, index: true, foreign_key: true, null: false
      t.integer :evaluator_id, foreign_key: :users, null: false
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end
  end
end
