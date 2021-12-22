require 'rails_helper'

RSpec.describe Section::QuestionSection, type: :model do
  before do
    @template = create(:section_template)
    @section = build(:dynamic_section, sba_application_id: 12, template: @template)
  end

  it { is_expected.to belong_to(:template) }

  context 'when you do not have a template' do
    before do
      @section.template = nil
      @section.valid?
    end

    it 'should not be valid' do
      expect(@section.errors[:template]).not_to be_empty
    end
  end

  describe "#question_presentations" do
    it 'should delegate to template' do
      expect(@template).to receive(:question_presentations)
      @section.question_presentations
    end  
  end
  
  describe "#questions" do
    it 'should delegate to template' do
      expect(@template).to receive(:questions)
      @section.questions
    end
  end

  describe "#class_path" do
    it 'should be "question_sections"' do # because it will be redirected?
      expect(@section.class_path).to eq('question_sections')
    end
  end
end
