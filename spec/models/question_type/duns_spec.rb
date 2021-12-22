require 'rails_helper'
 
RSpec.describe QuestionType::Duns, type: :model do
  before do
    # this factory can be created in spec/factories/question_types.rb
    @model = build(:duns)
  end
 
  context "return the correct view" do
    describe "#partial" do
      before do
        @outcome = @model.partial()
      end
 
      it 'should succeed' do
        expect(@outcome).to eq("question_types/duns")
      end
    end
  end
 
  context "when the user has provided a valid input" do
    describe "#evaluate" do
      before do
        @outcome = @model.evaluate('123456789', nil, nil)
      end
 
      it 'should succeed' do
        expect(@outcome).to eq(Answer::SUCCESS)
      end
    end
  end
 end