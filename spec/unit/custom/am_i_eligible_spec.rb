RSpec.describe 'Custom::AmIEligible' do
  before do
    @section = double(question_presentations: [])
    @naics = double(eligible_naic_codes: [])
  end

  describe "#initialize" do
    it 'should not fail' do
      expect(Questionnaire).to receive(:get).and_return(double(root_section: @section))
      expect(CertificateType).to receive(:get).at_least(:once).and_return @naics
      expect { Custom::AmIEligible.new}.not_to raise_error
    end
  end
end