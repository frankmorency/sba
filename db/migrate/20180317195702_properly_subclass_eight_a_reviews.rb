class ProperlySubclassEightAReviews < ActiveRecord::Migration
  def change
    Review::EightA.where(type: 'Review::EightA').update_all type: 'Review::EightAInitial'
  end
end
