require 'rails_helper'
require 'date'

RSpec.describe "QuestionType::Null", type: :model do
  before do
    @model = build(:null_question_type)
  end

  describe "#evaluate" do
    it 'should always return SUCCESS' do
      expect(@model.evaluate('whatever', 'blahblah')).to eq(Answer::SUCCESS)
    end
  end

  describe "#cast" do
    it 'should always return nil' do
      expect(@model.cast(true)).to be_nil
      expect(@model.cast(false)).to be_nil
      expect(@model.cast("asdfasdf")).to be_nil
    end
  end

  context "return the correct view" do
    describe "#partial" do
      before do
        @outcome = @model.partial()
      end

      it 'should succeed' do
        expect(@outcome).to eq("question_types/null")
      end
    end
  end
end