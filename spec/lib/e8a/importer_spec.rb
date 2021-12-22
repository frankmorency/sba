require 'rails_helper'
require Rails.root.join("lib/e8a/importer.rb")

RSpec.describe E8A::Importer do
  let(:subject) { E8A::Importer.new("", "") }
  describe "#read_agency_office_csv" do
    before do
      subject.read_agency_office_csv
    end

    it 'should populate the @agency_office_map hash' do
      expect(subject.instance_variable_get('@agency_office_map')).to be_a_kind_of(Hash)
      expect(subject.instance_variable_get('@agency_office_map').keys.length).to eq(220)
    end
  end

  describe "#read_district_office_csv" do
    before do
      subject.read_district_office_csv
    end

    it 'should populate the @district_office_map hash' do
      expect(subject.instance_variable_get('@district_office_map')).to be_a_kind_of(Hash)
      expect(subject.instance_variable_get('@district_office_map').keys.length).to eq(116)
    end
  end

  describe "#agency_co" do

    context "name in params" do
      let(:params_with_name) {{"RLRECVRNM" => "sample-name", "RLRECVRPHNNMB" => "1111111111", "RLRECVRSTR1TXT" => "sample-address1",
                               "RLRECVRSTR2TXT" => "sample-address2", "RLRECVRCTYNM" => "sample-city", "STCD" => "sample-state",
                               "ZIP5CD" => "sample-zip"}}
      before do
        @agency_co = subject.agency_co(params_with_name)
      end

      it 'should create @agency_co' do
        expect(@agency_co.first_name).to eq("sample-name")
        expect(@agency_co.last_name).to eq("sample-name")
        expect(@agency_co.phone).to eq("1111111111")
        expect(@agency_co.address1).to eq("sample-address1")
        expect(@agency_co.address2).to eq("sample-address2")
        expect(@agency_co.city).to eq("sample-city")
        expect(@agency_co.state).to eq("sample-state")
        expect(@agency_co.zip).to eq("sample-zip")
      end
    end

    context "no name in params" do
      let(:params_without_name) {{"RLRECVRNM" => "", "RLRECVRPHNNMB" => "1111111111", "RLRECVRSTR1TXT" => "sample-address1",
                               "RLRECVRSTR2TXT" => "sample-address2", "RLRECVRCTYNM" => "sample-city", "STCD" => "sample-state",
                               "ZIP5CD" => "sample-zip"}}
      before do
        @agency_co = subject.agency_co(params_without_name)
      end

      it 'should have a nil @agency_co' do
        expect(@agency_co.nil?).to be_truthy
      end
    end
  end

  describe "#program" do
     it "returns 'eight_a' program" do
       expect(subject.program.name).to eq('eight_a')
     end
  end
end
