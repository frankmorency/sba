class CreateNotes < ActiveRecord::Migration
  def change

    # The notes table tracks comments / notes made on various entities in the system
    create_table :notes do |t|
      t.integer :notated_id   # Polymorphic: the id of the entity or model that is being commented on
      t.text :notated_type    # Polymorphic: the type (model name) of the entity that is being commented on
      t.text :title           # The title of the comment
      t.text :body            # The message / content of the comment itself
      t.integer :author_id    # References the user table - this is the author of the comment
      t.boolean :published    # Is this comment published or not

      t.datetime :deleted_at  # Used for soft deletes
      t.timestamps null: false
    end

    add_index :notes, [:notated_type, :notated_id, :deleted_at], name: :index_notes_on_notated
    add_index :notes, [:author_id, :deleted_at], name: :index_notes_on_author_d

    add_foreign_key :notes, :users, column: :author_id
  end
end
