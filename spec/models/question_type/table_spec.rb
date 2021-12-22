require 'rails_helper'

RSpec.describe QuestionType::Table, type: :model do
  it { is_expected.to validate_uniqueness_of(:name) }

  context "build answer for the table question" do
    before do
      @model = build(:table_question_type)
    end

    context "should work with strategy" do
      before do
        class MockPresentation
          def unique_id
            123
          end
          def failure_message
            "failure message"
          end

          def maybe_message
            "maybe_message"
          end
          def question
            FactoryBot.build(:table_question_1_strategy_notes_receivables, question_type: @model)
          end
        end

        @app  = create(:sba_application, skip_copy_sections_and_rules: true)
        @user = vendor_user
        @mock_presentation = MockPresentation.new
        @data = {
            details: {'11':{'original_balance':"1233.45"}, '12':{'original_balance':"1.46"}}.to_json,
            value: "yes"
        }
        @answered_for = FactoryBot.build(:business_partner, sba_application_id: @app.id)
        @answer = @model.build_answer(@user, @app.id, @mock_presentation, @answered_for, @data)
      end

      it "should set details field" do
        expect(@answer.details.to_json).to eq(@data[:details])
      end

      it "should calculate aggregations based on strategy we pass in" do
        expect(@answer.value["assets"]).to eq(BigDecimal("1234.91"))
      end
    end

    pending "should not allow empty details if value is yes"
    pending "should fail if invalid json is sent"
    pending "should fail if details data is a string instead of JSON"
  end
end
