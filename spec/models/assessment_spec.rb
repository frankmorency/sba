require 'rails_helper'

RSpec.describe Assessment, type: :model do
  it { is_expected.to belong_to(:review) }
  it { is_expected.to belong_to(:the_assessed) }
  it { is_expected.to belong_to(:assessed_by) }
  it { is_expected.to belong_to(:note) }

  before do
    @model = Assessment.new
  end

  describe "#status" do
    before do
      expect(@model).to receive(:assessed_by_analyst).and_return(true)
    end

    it 'should be provided' do
      expect(@model).not_to be_valid
      expect(@model.errors[:status]).to include("can't be blank")
    end

    context "with a valid status" do
      it 'should not be valid' do
        @model.status = "bogus"
        expect(@model).not_to be_valid
        expect(@model.errors[:status]).to include("is not included in the list")
      end
    end

    context "without a valid status" do
      it 'should be valid' do
        @model.status = 'Confirmed'
        @model.valid?
        expect(@model.errors[:status]).to be_empty
      end
    end
  end

  describe "#the_assessed" do
    before do
      expect(@model).to receive(:assessed_by_analyst).and_return(true)
    end

    it 'should be provided' do
      expect(@model).not_to be_valid
      expect(@model.errors[:the_assessed]).to include("can't be blank")
    end
  end

  describe "#assessed_by" do
    it 'should be provided' do
      expect(@model).to receive(:assessed_by_analyst).and_return(true)
      expect(@model).not_to be_valid
      expect(@model.errors[:assessed_by]).to include("can't be blank")
    end

    it 'should be an owner' do
      @model.assessed_by = User.new
      expect(@model).not_to be_valid
      expect(@model.errors[:assessed_by]).to include('must be an sba analyst')
    end
  end

  describe "#the_assessed_type" do
    it 'should be limited...' do
      expect(@model).to receive(:assessed_by_analyst).and_return(true)
      @model.the_assessed_type = 'SomeConstEvalRandomHack'
      @model.valid?
      expect(@model.errors[:the_assessed_type]).to include("is not included in the list")
    end
  end

  describe "note_body" do
    before do
      expect(@model).to receive(:note).and_return(Struct.new(:body).new('this is the body'))
    end

    it 'should return the body of the note' do
      expect(@model.note_body).to eq('this is the body')
    end
  end

  describe "note_body=" do
    it 'should be a (published) note for that assessment' do
      expect(@model).to receive(:build_note).with(body: 'This is my note', published: true)
      @model.note_body = "This is my note"
    end
  end

  describe "#short?" do
    context "when the body of the note is > 100 characters" do
      it 'should be false' do
        expect(Assessment.new(note: Note.new(body: "a" * 101))).not_to be_short
      end
    end

    context "when the body of the note is < 100 characters" do
      it 'should be true' do
        expect(Assessment.new(note: Note.new(body: "a" * 99))).to be_short
      end
    end

    context "when there's no note" do
      it 'should be true' do
        expect(Assessment.new()).to be_short
      end
    end

    context "when the note has no body" do
      it 'should be true' do
        expect(Assessment.new(note: Note.new(body: nil))).to be_short
      end
    end
  end
end
