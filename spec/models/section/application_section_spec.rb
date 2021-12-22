require 'rails_helper'

RSpec.describe Section::ApplicationSection, type: :model do
  before do
    @section = build(:application_section)
  end

  it "should be displayable by default" do
    @section.save!
    expect(@section).to be_displayable
  end

  it 'should be able to be set non displayable' do
    @section.displayable = false
    @section.save!
    expect(@section).not_to be_displayable
  end

  describe "#class_path" do
    it 'should be "application_sections"' do
      expect(Section::ApplicationSection.new.class_path).to eq('application_sections')
    end
  end
end
