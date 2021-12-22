require 'rails_helper'

RSpec.describe Section::Template, type: :model do
  before do
    @questionnaire = create(:basic_questionnaire)
    @template = @questionnaire.create_sections! do
      template 'static_template', 0, displayable: false do
        template 'other_template', 0
      end
    end
  end

  it { is_expected.to have_many(:sections) }

  describe "#class_path" do
    it 'should be raise an error because it is not intended to be accessed directly' do
      expect { Section::Template.new.class_path}.to raise_error(RuntimeError)
    end
  end

  describe "root template" do
    it "should be non displayable" do
      expect(@template).not_to be_displayable
    end
  end

  describe "child template" do
    it "should be displayable" do
      expect(@template.children.first).to be_displayable
    end
  end

  describe "#customize_title" do
    context "when the title doesn't include {value}" do
      before do
        @title = @template.customize_title('Mike')
      end

      it 'should set the new title to the template title' do
        expect(@title).to eq('Static Template')
      end
    end

    context "when the title has {value} at the front" do
      before do
        @template.title = '{value} Template'
        @title = @template.customize_title('Mike')
      end

      it 'should set the new title dynamically' do
        expect(@title).to eq('Mike Template')
      end
    end

    context "when the title has {value} at the end" do
      before do
        @template.title = 'Template {value}'
        @title = @template.customize_title('Mike')
      end

      it 'should set the new title dynamically' do
        expect(@title).to eq('Template Mike')
      end
    end

    context "when the title has {value} in the middle" do
      before do
        @template.title = 'Some {value} Template'
        @title = @template.customize_title('Mike')
      end

      it 'should set the new title dynamically' do
        expect(@title).to eq('Some Mike Template')
      end
    end
  end
end
