require 'rails_helper'

RSpec.describe Assignment, type: :model do
  it { is_expected.to  belong_to(:review) }
  it { is_expected.to  belong_to(:supervisor) }
  it { is_expected.to  belong_to(:owner) }
  it { is_expected.to  belong_to(:reviewer) }

  before do
    @model = Assignment.new
    @supervisor = User.new
    @reviewer = User.new
    @owner = User.new
    @model.reviewer = @reviewer
    @model.supervisor = @supervisor
    @model.owner = @owner
  end

  describe "#reviewer" do
    it 'must be an analyst' do
      expect(@reviewer).to receive(:can?).and_return false
      expect(@model).not_to be_valid
      expect(@model.errors[:reviewer]).to include('must be an sba analyst')
    end
  end

  describe "#supervisor" do
    it 'must be an analyst' do
      expect(@supervisor).to receive(:can?).and_return false
      expect(@model).not_to be_valid
      expect(@model.errors[:supervisor]).to include('must be an sba analyst')
    end
  end

  describe "#owner" do
    it 'must be an analyst' do
      expect(@owner).to receive(:can?).and_return false
      expect(@model).not_to be_valid
      expect(@model.errors[:owner]).to include('must be an sba analyst')
    end
  end
end
