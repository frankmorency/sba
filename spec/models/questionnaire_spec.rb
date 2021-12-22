require 'rails_helper'

RSpec.describe Questionnaire, type: :model do
  it { is_expected.to have_many(:sections) }
  it { is_expected.to have_many(:evaluation_purposes) }
  it { is_expected.to belong_to(:certificate_type) }
  it { is_expected.to belong_to(:program) }

  before do
    @model = Questionnaire::SimpleQuestionnaire.new
  end

  describe "#create_sections!" do
    it 'should just delegate to QuestionnaireDSL' do
      block = Proc.new {}

      expect(QuestionnaireDSL).to receive(:create!).with(@model, &block)
      @model.create_sections! &block
    end
  end

  describe "#create_rules!" do
    it 'should just delegate to QuestionnaireDSL' do
      block = Proc.new {}

      expect(QuestionnaireDSL).to receive(:create!).with(@model, &block)
      @model.create_sections! &block
    end
  end

  describe "#start_application" do
    before do
      @org = build(:organization)
    end

    it 'should just delegate to sba_applications.new' do
      expect(SbaApplication::SimpleApplication).to receive(:new)
      @model.start_application(@org)
    end
  end
end

