class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.text     "name",        null: false
      t.datetime "deleted_at"
      t.timestamps
    end
    add_index "tags", ["deleted_at"], name: "index_tags_on_deleted_at", using: :btree

    Tag.reset_column_information
    set_table_comment :tags, "Tags that are associated to SBA notes that analysts create. Used for filtering."
    set_column_comment :tags, :name, "name of the tag"

    ["BOS Analysis", "Control", "Character", "Eligibility", "Ownership", "Potential for Success",
     "Adverse Action", "Business Development", "Letter of Intent", "Retain Firm", "Review Complete"].each do |name|
      Tag.create!(name: name)
    end
  end
end
