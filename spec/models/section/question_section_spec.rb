require 'rails_helper'

RSpec.describe Section::QuestionSection, type: :model do
  before do
    @section = build(:question_section)
  end

  it "should be displayable" do
    @section.save!
    expect(@section).to be_displayable
  end

  describe "#update_progress" do
    # document stuff
  end

  describe "#get_attached_document_ids" do
    # document stuff
  end

  describe "#class_path" do
    it 'should be "question_sections"' do
      expect(Section::QuestionSection.new.class_path).to eq('question_sections')
    end
  end
end
