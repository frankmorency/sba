class CreateFullAddressQuestionType < ActiveRecord::Migration
  def change
    # "full_address"
    full_address = QuestionType::FullAddress.new name: 'full_address', title: 'Full Address'
    full_address.save!
  end
end
