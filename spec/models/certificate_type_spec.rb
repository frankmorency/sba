require 'rails_helper'

RSpec.describe CertificateType, type: :model do

  it { is_expected.to have_many(:questionnaires) }
  it { is_expected.to have_many(:eligible_naic_codes) }
  it { is_expected.to have_many(:evaluation_purposes) }
  it { is_expected.to have_many(:certificates) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_uniqueness_of(:name) }

  describe "#super_short_name" do
    before do
      @model = build(:certificate_type, name: 'jose')
    end

    it 'should be the name upcased' do
      expect(@model.super_short_name).to eq('JOSE')
    end
  end

  describe "#short_name" do
    before do
      @model = build(:certificate_type, name: 'jose')
    end

    it 'should be the name upcased plus Certification' do
      expect(@model.short_name).to eq('JOSE Certification')
    end
  end

  describe "#display_summary_thanks?" do
    before do
      @mpp_model = build(:certificate_type, name: 'mpp')
      @edwosb_model = build(:certificate_type, name: 'edwosb')
      @wosb_model = build(:certificate_type, name: 'wosb')
    end

    it 'should return true for mpp' do
      expect(@mpp_model.display_summary_thanks?).to be true
    end

    it 'should return false for edwosb' do
      expect(@edwosb_model.display_summary_thanks?).to be false
    end

    it 'should return false wosb' do
      expect(@wosb_model.display_summary_thanks?).to be false
    end
  end

  describe "#display_pdf_letter_tab?" do
    before do
      @mpp_model = build(:certificate_type, name: 'mpp')
      @edwosb_model = build(:certificate_type, name: 'edwosb')
      @wosb_model = build(:certificate_type, name: 'wosb')
    end

    it 'should return false for mpp' do
      expect(@mpp_model.display_pdf_letter_tab?).to be false
    end

    it 'should return true for edwosb' do
      expect(@edwosb_model.display_pdf_letter_tab?).to be true
    end

    it 'should return true for wosb' do
      expect(@wosb_model.display_pdf_letter_tab?).to be true
    end
  end

  describe "#has_financial_review_section?" do
    before do
      @mpp_model = build(:certificate_type, name: 'mpp')
      @edwosb_model = build(:certificate_type, name: 'edwosb')
      @wosb_model = build(:certificate_type, name: 'wosb')
    end

    it 'should return false for mpp' do
      expect(@mpp_model.has_financial_review_section?).to be false
    end

    it 'should return true for edwosb' do
      expect(@edwosb_model.has_financial_review_section?).to be true
    end

    it 'should return false for wosb' do
      expect(@wosb_model.has_financial_review_section?).to be false
    end
  end


end
