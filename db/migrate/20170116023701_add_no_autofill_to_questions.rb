class AddNoAutofillToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :prepopulate, :boolean, default: false
  end
end
