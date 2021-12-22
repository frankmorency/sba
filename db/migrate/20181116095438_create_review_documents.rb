class CreateReviewDocuments < ActiveRecord::Migration
  def change
    create_table :review_documents do |t|
      t.integer :review_id
      t.integer :document_id
      t.datetime "deleted_at"
      t.timestamps null: false
    end
    add_index :review_documents, [:review_id, :document_id]
  end
end
