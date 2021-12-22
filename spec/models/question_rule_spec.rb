require 'rails_helper'

RSpec.describe QuestionRule, type: :model do
  it { is_expected.to belong_to(:question_type) }

  describe "#to_s" do
    it 'should describe the rule' do
      expect(QuestionRule.new(mandatory: true, capability: 'add_comment').to_s).to eq('require add_comment')
      expect(QuestionRule.new(mandatory: false, capability: 'add_attachment').to_s).to eq('allow add_attachment')
    end
  end

  describe "#validation_settings" do
    describe "when mandatory" do
      before do
        @q = double('question', dom_id: 'question_36')

        @qr = QuestionRule.new(mandatory: true, capability: 'add_comment', condition: 'equal_to', value: true)
        @qr.question_type = QuestionType::Boolean.new
      end

      it 'should return requirements in the proper format for jquery validator' do
        expect(@qr.validation_settings(@q)).to eq({
                                                      rules: {
                                                          required: ["input[name='question_36']:checked", "equal_to", "t"]
                                                      },
                                                      messages: {
                                                          required: "Comment is required"
                                                      }
                                                   }
                                               )
      end
    end

    describe "when optional" do
      before do
        @q = double('question', dom_id: 'question_36')

        @qr = QuestionRule.new(mandatory: false, capability: 'add_comment', condition: 'equal_to', value: true)
        @qr.question_type = QuestionType::Boolean.new
      end

      it 'should return requirements in the proper format for jquery validator' do
        expect(@qr.validation_settings(@q)).to eq({
                                                      rules: {
                                                          required:  false
                                                      }
                                                  }
                                               )
      end
    end
  end
end