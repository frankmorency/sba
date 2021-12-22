class CreateWorkflowChanges < ActiveRecord::Migration
  def change
    # This workflow_changes table keeps a history of all workflow state transitions (for applications, certificates, reviews, etc.)
    create_table :workflow_changes do |t|
      t.text :model_type      # Polymorphic association:  the class name of the model whose workflow is being tracked:  SbaApplication or Certificate or CertificateReview::InitialReview, for instance
      t.integer :model_id     # Polymorphic association:  the id name of the model whose workflow is being tracked
      t.text :workflow_state  # the state the workflow gem just transitioned to for that model
      t.integer :user_id      # the user associated with this transition.  For instance: the vendor admin that submitted an application or the sba analyst that started a review
      t.datetime :deleted_at  # used for soft deletes

      t.timestamps null: false
    end

    add_index :workflow_changes, [:model_type, :model_id, :deleted_at], name: :index_assignments_on_model_d
    add_index :workflow_changes, [:user_id, :deleted_at], name: :index_assignments_on_user_d

    add_foreign_key :workflow_changes, :users
  end
end
