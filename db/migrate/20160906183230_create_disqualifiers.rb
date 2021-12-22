class CreateDisqualifiers < ActiveRecord::Migration
  def change
    create_table :disqualifiers do |t| # adding a disqualifier record to a question presentation sets it up so that certain answers to that question can ellicit a "You are disqualified" page for the questionnaire associated question presentation
      t.text :value # the value for which disqualification happens
      t.text :message # the message to display to the user as to why

      t.timestamps null: false
    end

    add_column :question_presentations, :disqualifier_id, :integer, index: true
    add_foreign_key :question_presentations, :disqualifiers
  end
end
