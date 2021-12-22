require 'rails_helper'

RSpec.describe QuestionType::Address, type: :model do
  before do
    @model = build(:address_question_type)
  end

  context "return the correct view" do
    describe "#partial" do
      before do
        @outcome = @model.partial()
      end

      it 'should succeed' do
        expect(@outcome).to eq("question_types/address")
      end
    end
  end

end