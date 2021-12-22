class CreateAssignments < ActiveRecord::Migration
  def change

    # The assignments table keeps track of which analysts are working on different reviews
    create_table :assignments do |t|
      t.references :review            # the review for which the analyst has ownership
      t.integer :supervisor_id        # references the user table - must be an analyst - this is the supervisor for this review
      t.integer :owner_id             # references the user table - must be an analyst - this is the owner for this review
      t.integer :reviewer_id          # references the user table - must be an analyst - this is the current reviewer for this review

      t.datetime :deleted_at          # used for soft deletes
      t.timestamps null: false
    end

    add_index :assignments, [:review_id, :deleted_at], name: :index_assignments_on_reviewd
    add_index :assignments, [:supervisor_id, :deleted_at], name: :index_assignments_on_supd
    add_index :assignments, [:owner_id, :deleted_at], name: :index_assignments_on_ownd
    add_index :assignments, [:reviewer_id, :deleted_at], name: :index_assignments_on_revd

    add_foreign_key :assignments, :reviews
    add_foreign_key :assignments, :users, column: :supervisor_id
    add_foreign_key :assignments, :users, column: :owner_id
    add_foreign_key :assignments, :users, column: :reviewer_id
    add_foreign_key :reviews, :assignments, column: :current_assignment_id

  end
end
