require 'rails_helper'

RSpec.describe QuestionType, type: :model do
  it { is_expected.to have_many(:questions) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_presence_of(:title) }

  context 'when type is unknown' do
    before do
      @model = build(:question_type)
      @model.name = 'asdf9023sadkfjasldkfj29'
    end

    it 'should not be valid' do
      expect(@model).not_to be_valid
      expect(@model.errors).to include(:name)
      expect(@model.errors[:name]).to include('must be a valid question type')
    end
  end

  describe '.types' do
    it 'should include real_estate' do
      expect(QuestionType::TYPES).to include('real_estate')
    end
  end

  describe "#sub_questions" do
    it 'should be empty by default' do
      @model = build(:question_type)
      expect(@model.sub_questions).to be_empty
    end
  end

  describe "#partial" do
    it 'should raise an error because it is supposed to be subclassed' do
      expect { @model.partial }.to raise_error(StandardError)
    end
  end
end


describe QuestionType::Percentage do
  describe "#evaluate" do
    it 'should always return success' do
      expect(QuestionType::Percentage.new(name: 'percentage').evaluate(nil, nil)).to eq(Answer::SUCCESS)
    end
  end

  describe "#partial" do
    it 'should be question_types/percentage' do
      expect(QuestionType::Percentage.new.partial).to eq('question_types/percentage')
    end
  end
end

describe QuestionType::NaicsCode do
  describe "#validation_settings" do
    it 'should be a hash' do
      expect(QuestionType::NaicsCode.new.validation_settings).to be_a(Hash)
    end
  end
end
