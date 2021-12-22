require 'rails_helper'

RSpec.describe EvaluationHistory, type: :model do
  it { is_expected.to belong_to(:evaluator) }
  it { is_expected.to belong_to(:evaluable) }

  it { is_expected.to validate_presence_of(:category) }
  it { is_expected.to validate_presence_of(:value) }
  it { is_expected.to validate_presence_of(:stage) }
  it { is_expected.to validate_presence_of(:evaluator_id) }

=begin
  before do
    @user = create(:user_random)
    @user.add_role :sba_analyst
    @eight_a_submitted = create(:eight_a_display_application_initial, workflow_state: 'submitted')
    @evaluation_history = EvaluationHistory.create({sba_application_id: @eight_a_submitted.id, evaluator_id: @user.id, evaluation_type: 'recommendation', evaluation_value: 'eligible', evaluation_stage: 'initial'})
  end

  describe ".evaluation_stage_display" do
    it 'should display the correct stage' do
      expect(@evaluation_history.evaluation_stage_display).to eq('Initial Application')
    end
  end

  describe ".decision_display" do
    it 'should display the correct decision' do
      expect(@evaluation_history.decision_display).to eq('Recommended eligible')
    end
  end

  describe ".evaluator_name" do
    it 'should display the evaluator\'s name' do
      expect(@evaluation_history.evaluator_name).to eq('mike morgan')
    end
  end

  describe ".evaluator_role" do
    it 'should display the evaluator\'s role' do
      expect(@evaluation_history.evaluator_role).to eq('Analyst')
    end
  end

  describe ".outcome" do
    it 'should display the correct outcome' do
      expect(@evaluation_history.outcome).to eq('positive')
    end
  end

  describe ".outcome_icon" do
    it 'should display the correct outcome_icon' do
      expect(@evaluation_history.outcome_icon).to eq('#check-circle')
    end
  end
=end
end
