require 'rails_helper'

RSpec.describe Question, type: :model do
  it { is_expected.to have_many :question_presentations }
  it { is_expected.to have_many :applicable_questions }
  it { is_expected.to belong_to :question_type }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_uniqueness_of(:name) }

  describe "#current_answer" do
    before do
      @answer1 = create(:answer_boolean)
      @question = @answer1.question
      @answer2 = create(:answer_boolean, question: @answer1.question, value: {value: 'no'})

      expect(@question).to eq(@answer2.question)
    end

    it 'should be the most recent answer to this question' do
      # ignoring the sba application and answered for
      expect(@question.current_answer(nil, nil)).to eq(@answer2)
    end
  end
end
