require 'rails_helper'

RSpec.describe SubQuestion, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:question_type) }

  before do
    @picklist = QuestionType::Picklist.first

    @subquestion = SubQuestion.new question_type: 'picklist', name: 'real_estate_type', title: 'What type of Other Real Estate do you own?', position: 1, possible_values: ['Other Residential', 'Commercial', 'Industrial', 'Land', 'Other Real Estate'], id: "6_1"
  end

  describe "#==(other_subquestion)" do
    before do
      @other = double('subquestion', unique_id: '6_1')
    end

    it 'should compare based on unique_id' do
      expect(@subquestion).to eq(@other)
    end
  end

  describe "#has_table_rule?" do
    it 'should always return false' do
      expect(@subquestion.has_table_rule?).to be_falsey
    end
  end

  describe "#failure_message" do
    it 'should be something random, cause we wont show it' do
      expect(@subquestion.failure_message).to eq('Something went terribly wrong')
    end
  end

  describe "#maybe_message" do
    it 'should be something random, cause we wont show it' do
      expect(@subquestion.maybe_message).to eq("We're just not sure about this")
    end
  end

  describe "#dom_id" do
    
  end

  describe "#rules" do
    it 'should be empty for now' do
      expect(@subquestion.rules).to be_empty
    end
  end

  describe "#unique_id" do
    it 'should be the id' do
      expect(@subquestion.unique_id).to eq('6_1')
    end
  end

  describe "#as_json" do
    before do
      @json = @subquestion.to_json
    end

    it 'should marshal the proper data' do
      expect(@subquestion.as_json).to eq({
                                             id: '6_1',
                                             question_type: 'picklist',
                                             name: 'real_estate_type',
                                             header: nil,
                                             title: 'What type of Other Real Estate do you own?',
                                             title_wrapper_tag: nil,
                                             position: 1,
                                             possible_values: ['Other Residential', 'Commercial', 'Industrial', 'Land', 'Other Real Estate'],
                                             positive_response: nil
                                         })
    end

    describe "#from_json" do
      before do
        @marshalled_subquestion = SubQuestion.from_json(@json)
      end

      it 'should be able to load that marshalled data' do
        expect(@marshalled_subquestion.question_type).to eq(@picklist)
        [:name, :title, :position, :possible_values, :positive_response, :id].each do |field|
          expect(@marshalled_subquestion.send(field)).to eq(@subquestion.send(field))
        end
      end
    end
  end
end
