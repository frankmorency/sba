require 'rails_helper'

RSpec.describe QuestionPresentation, type: :model do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:section) }
  it { is_expected.to belong_to(:disqualifier) }

  it { is_expected.to delegate_method(:current_answer).to(:question) }

  before do
    @model = QuestionPresentation.new
    @model.valid?
  end

  describe "#title" do
    subject { @model.title }

    context "when question_title_override is present" do
      before do
        @model.question_override_title = "The title"
      end

      it 'should use it' do
        is_expected.to eq("The title")
      end
    end

    context "when question_title_override is blank" do
      before do
        @model.question_override_title = ""
        @model.question = build(:question, title: "The question title")
      end

      it 'should use the question title' do
        is_expected.to eq("The question title")
      end
    end
  end
end
