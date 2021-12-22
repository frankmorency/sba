require 'rails_helper'
include ActionDispatch::TestProcess

RSpec.describe AgencyRequirementDocument, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:agency_requirement) }

  before do
      dt = "Letter of Offer"
      user = FactoryBot.create :user
      @ar = AgencyRequirement.create!(title: "title", agency_office: AgencyOffice.first, agency_contract_type: AgencyContractType.first,
                                      user_id: user.id)
  	  @document1 = AgencyRequirementDocument.create!(original_file_name: 'valid.pdf',
                                                     document_type: dt, is_active: true, user_id: user.id, agency_requirement: @ar)
      @valid_pdf = fixture_file_upload("#{Rails.root}/spec/fixtures/files/valid.pdf", 'application/pdf')
      @invalid_pdf = fixture_file_upload("#{Rails.root}/spec/fixtures/files/IMG_0260.pdf", 'image/png')
  end

  describe ".is_pdf?" do
    context "when given a valid PDF document" do
      it "returns true " do
    	  expect(AgencyRequirementDocument.is_pdf?(@valid_pdf)).to eq(true)
      end    	
    end
    context "when given a non-PDF document" do
      it "returns false" do
    	  expect(AgencyRequirementDocument.is_pdf?(@invalid_pdf)).to eq(false)
      end    	
    end    
  end

  describe ".file_key" do
      it "does not raise_error" do
        expect{@document1.file_key}.to_not raise_error(NotImplementedError)
      end
  end

  describe ".set_stored_file_name" do
    it "sets stored_file_name to the pattern 'UUID-CurrentTime'" do
      expect(@document1.stored_file_name).to match(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}-\d*.\d{5}/)
    end
  end

  describe ".folder_name" do
    it "returns name with patter 'agency_requirement_self.id'" do
      expect(@document1.folder_name).to eq("agency_requirement_#{@ar.id}")
    end
  end

  describe ".check_av_status" do
    it "sets av_status to 'Not Scanned'" do
      expect(@document1.av_status).to eq("Not Scanned")
    end
  end
end
