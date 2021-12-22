require 'rails_helper'

RSpec.describe 'Answer Strategies', type: :model do
  before do
    @app = create(:sba_application, skip_copy_sections_and_rules: true)

    @answers = double('association_proxy', find_by: nil, new: Answer.new)

    @user = double('user', answers: @answers)
    @presentation = double('question_presentation', unique_id: 42, failure_message: 'you fail', maybe_message: 'but maybe...')
    @biz_partner = BusinessPartner.new
    @data = {
        value: 5,
        comment: 'I suggest this',
        question_text: 'What is five?'
    }

    allow(@answers).to receive(:for_application).with(@app, @presentation, nil).and_return nil
    allow(@answers).to receive(:for_application).with(@app, @presentation, @biz_partner).and_return nil
  end

  describe 'Standard answer strategies' do
    [Strategy::Answer::Base, Strategy::Answer::Address, Strategy::Answer::Date, Strategy::Answer::Boolean, Strategy::Answer::YesNoNa, Strategy::Answer::NaicsCode, Strategy::Answer::Picklist].each do |klass|
      before do
        @strategy = klass.new(@user, @app.id, @presentation, @biz_partner, @data)
      end

      describe 'starting off' do
        it 'should be valid' do
          expect(@strategy).to be_valid
        end

        it "should have no errors" do
          expect(@strategy.errors).to be_empty
        end

        describe "setting details and value" do
          before do
            @strategy.set_details
            @strategy.set_value

            @answer = @strategy.answer
          end

          it 'should properly setup the answer' do
            expect(@answer.sba_application_id).to eq(@app.id)
            expect(@answer.question_id).to eq(42)
            expect(@answer.answered_for).to eq(@biz_partner)
            expect(@answer.comment).to eq(@data[:comment])
            expect(@answer.question_text).to eq(@data[:question_text])
            expect(@answer.explanations).to eq({failure: @presentation.failure_message, maybe: @presentation.maybe_message})
            expect(@answer.brand_new_answered_for_ids).to eq([])

            expect(@answer.value).to eq({'value' => @data[:value]})
          end
        end
      end
    end
  end

  describe Strategy::Answer::AssessedTaxes do
    describe "#set_value" do
      context "when the details are blank" do
        before do
          @data[:details] = nil
          @strategy = Strategy::Answer::AssessedTaxes.new(@user, @app.id, @presentation, @biz_partner, @data)
          @strategy.set_details
          @strategy.set_value
        end

        it 'should set liabilities value to zero' do
          expect(@strategy.answer.value['liabilities']).to eq('0')
        end
      end

      context "when the details are provided" do
        before do
          @data[:details] = {
              1 => {'amount' => 10},
              2 => {'amount' => 20},
              3 => {'amount' => 30},
              4 => {'amount' => 40},
              5 => {'amount' => 50}
          }.to_json
          @strategy = Strategy::Answer::AssessedTaxes.new(@user, @app.id, @presentation, @biz_partner, @data)
          @strategy.set_details
          # why does it have to set both places
          @strategy.answer.details = @data[:details]
          @strategy.set_value
        end

        it 'should sum the values in details and set amount' do
          expect(@strategy.answer.value['liabilities']).to eq(BigDecimal("150"))
        end
      end
    end
  end

  describe Strategy::Answer::Table do
    describe "#set_details" do
      context "when the answer is yes" do
        before do
          @data[:value] = 'yes'
          @data[:details] = 'gimme the deets'
          @strategy = Strategy::Answer::Table.new(@user, @app.id, @presentation, @biz_partner, @data)
          @strategy.set_details
        end

        pending 'should set details properly' do
          expect(@strategy.answer.details).to eq('gimme the deets')
        end
      end

      context "when the answer is not yes" do
        before do
          @data[:value] = 'no'
          @data[:details] = 'gimme the deets'
          @strategy = Strategy::Answer::Table.new(@user, @app.id, @presentation, @biz_partner, @data)
          @strategy.set_details
          @strategy.answer.details = @data[:details]
        end

        it 'should set nil out details' do
          expect(@strategy.answer.details).to be_nil
        end
      end
    end
  end

  describe Strategy::Answer::TextField do
    describe "#validate" do

      context 'when the user has entered more than max characters allowed' do
        before do
          @data[:value] = '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'
          @strategy = Strategy::Answer::TextField.new(@user, @app.id, @presentation, @biz_partner, @data)
          allow(@strategy).to receive(:question_type).and_return QuestionType::TextField.new(name: 'text_field_single_line', title: 'Text Field Single Line', config_options: {num_lines: 'single'})

          @strategy.set_details
          @strategy.set_value

          @strategy.validate
        end

        it "should generate an error message" do
          expect(@strategy.errors[0]).to eq("Single line textfield answers have a maximum character length of #{QuestionType::TextField::DEFAULT_SINGLE_LINE_MAX_CHARACTERS_ALLOWED}")
        end

      end

      context 'when the user has entered less than min characters allowed' do
        before do
          @data[:value] = ''
          @strategy = Strategy::Answer::TextField.new(@user, @app.id, @presentation, @biz_partner, @data)
          allow(@strategy).to receive(:question_type).and_return QuestionType::TextField.new(name: 'text_field_single_line', title: 'Text Field Single Line', config_options: {num_lines: 'single'})

          @strategy.set_details
          @strategy.set_value

          @strategy.validate
        end

        it "should generate an error message" do
          expect(@strategy.errors[0]).to eq("Single line textfield answers have a minimum character length of #{QuestionType::TextField::DEFAULT_SINGLE_LINE_MIN_CHARACTERS_ALLOWED}")
        end
      end

    end
  end


end
