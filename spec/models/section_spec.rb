require 'rails_helper'

RSpec.describe Section, type: :model do
  it { is_expected.to have_many(:question_presentations) }
  it { is_expected.to have_many(:assessments) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to [:questionnaire_id, :sba_application_id, :deleted_at] }
  it { is_expected.to validate_presence_of(:title) }

  describe ".sub_application_sections(user)" do
    before do
      @section = build(:master_section)
      @user = double('User')
      @app = double('SbaApplication')
      allow(@section).to receive(:user).and_return(@user)
      allow(@section).to receive(:sba_application).and_return(@app)
    end

    context 'when the user is a vendor' do
      before do
        allow(@user).to receive(:is_vendor?).and_return true
      end

      context 'and the application is in draft' do
        before do
          allow(@app).to receive(:draft?).and_return true
          allow(@app).to receive(:is_under_reconsideration?).and_return false
        end

        context 'and the application is not under reconsideration' do
          before do
            allow(@app).to receive(:is_under_reconsideration?).and_return false
          end

          it 'should include contributor sections' do
            expect(@section.send(:not_included, @user)).not_to include('Section::ContributorSection')
          end
        end
      end
    end
  end

  describe ".dynamic" do
    it 'should only return dynamic sections' do
      expect(Section).to receive(:where).with(dynamic: true)

      Section.dynamic
    end
  end

  describe ".displayable" do
    it 'should only return dynamic sections' do
      expect(Section).to receive(:where).with(displayable: true)

      Section.displayable
    end
  end

  describe ".without_parent" do
    it 'should only return dynamic sections' do
      expect(Section).to receive(:where).with(ancestry: nil)

      Section.without_parent
    end
  end

  describe "#class_path" do
    it 'should be "sections"' do
      expect(Section.new.class_path).to eq('sections')
    end
  end

  describe "#to_param" do
    before do
      @section = build(:question_section)
    end

    it 'should use the name of the section' do
      expect(@section.to_param).to eq(@section.name)
    end
  end

  describe "#to_s" do
    before do
      @section = create(:root_section, title: 'Root Section')
      create(:question_section, title: 'Child Section', parent: @section)
    end

    it 'should look pretty' do
      expect(@section.to_s).to eq("Root Section\n|__Child Section\n")
    end
  end
end
