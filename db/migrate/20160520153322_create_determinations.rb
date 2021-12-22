class CreateDeterminations < ActiveRecord::Migration
  def change

    # Determinations are the end result of a review
    create_table :determinations do |t|
      t.integer :decision        # this is an enumeration (see the determinations model) of possible decisions
      t.integer :decider_id      # who made the decision?  references user table

      t.datetime :deleted_at     # used for soft deletes
      t.timestamps null: false
    end

    add_index :determinations, [:decider_id, :deleted_at], name: :index_determ_on_decid_d
    add_index :reviews, [:determination_id, :deleted_at], name: :index_review_on_determ_d

    add_foreign_key :determinations, :users, column: :decider_id
    add_foreign_key :reviews, :determinations
  end
end
