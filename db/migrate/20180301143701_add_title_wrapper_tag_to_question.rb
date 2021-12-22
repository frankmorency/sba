class AddTitleWrapperTagToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :title_wrapper_tag, :string # adding the ability to wrap a question title with somthing other than h3
    Question.reset_column_information
  end
end
