require 'rails_helper'

RSpec.describe Note, type: :model do
  it { is_expected.to belong_to(:author) }
  it { is_expected.to belong_to(:notated) }

  describe ".published" do
    it 'should get all published notes' do
      expect(Note).to receive(:where).with(published: true)

      Note.published
    end
  end

  describe "#short?" do
    context "when the body of the note is > 100 characters" do
      it 'should be false' do
        expect(Note.new(body: "a" * 101)).not_to be_short
      end
    end

    context "when the body of the note is < 100 characters" do
      it 'should be true' do
        expect(Note.new(body: "a" * 99)).to be_short
      end
    end

    context "when the note has no body" do
      it 'should be true' do
        expect(Note.new(body: nil)).to be_short
      end
    end
  end
end
