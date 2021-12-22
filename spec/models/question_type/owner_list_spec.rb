require 'rails_helper'

RSpec.describe QuestionType::OwnerList, type: :model do
  before do
    @model = build(:owner_list_question_type)
  end

  context "return the correct view" do
    describe "#partial" do
      before do
        @outcome = @model.partial()
      end

      it 'should succeed' do
        expect(@outcome).to eq("question_types/owner_list")
      end
    end
  end
end