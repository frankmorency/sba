class CreateAssessments < ActiveRecord::Migration
  def change
    # The assessments table is where analysts store their notes and statuses on specific questions and sections of a questionnaire
    create_table :assessments do |t|
      t.references :review, foreign_key: true # it is part of a review
      t.references :note, foreign_key: true # it can have a note associated with it
      t.integer :assessed_by_id, foreign_key: :users # the assessor - analyst - a user
      t.string  :the_assessed_type, index: true # the thing we're assessing - either a question presentation (answer) or a section (signature section)
      t.integer :the_assessed_id, index: true # the id of that thing in the table - so the question presentation or section id
      t.string  :status # see the assessment.rb model for possible statuses

      t.datetime :deleted_at, index: true

      t.timestamps null: false
    end
  end
end
