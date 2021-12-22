require 'rails_helper'

RSpec.describe SbaApplication, type: :model do
  before do
    @sba_application = build(:basic_application, workflow_state: 'draft', is_current: true)
  end

  describe ".for_display" do
    context 'eight_a' do
      before do
        @eight_a_draft = create(:eight_a_display_application_initial, workflow_state: 'draft')
        @eight_a_submitted = create(:eight_a_display_application_initial, workflow_state: 'submitted')
        @eight_a_cert = create(:certificate_eight_a)

        @eight_a_submitted.update_attribute(:certificate_id, @eight_a_cert)

        @eight_a_annual_draft = create(:eight_a_display_application_annual, workflow_state: 'draft', certificate: @eight_a_cert)

        @displayables = SbaApplication.for_display
      end

      context 'initial apps' do
        context 'in draft' do
          it 'should show' do
            expect(@displayables).to include(@eight_a_draft)
          end
        end

        context 'submitted' do
          it 'should NOT show' do
            expect(@displayables).not_to include(@eight_a_submitted)
          end
        end
      end

      context 'annual reviews' do
        context 'in draft' do
          it 'should show' do
            expect(@displayables).to include(@eight_a_annual_draft)
          end
        end

        context 'submitted' do
          before do
            @eight_a_annual_draft.update_attribute(:workflow_state, 'submitted')
            @eight_a_annual_submitted = @eight_a_annual_draft
          end

          it 'should show' do
            expect(@displayables).to include(@eight_a_annual_submitted)
          end
        end
      end
    end
  end

  describe ".in_an_open_state" do
    it 'should include draft under_review and returned' do
      expect(SbaApplication).to receive(:where).with({:workflow_state=>["draft", "returned"]})
      SbaApplication.in_an_open_state
    end
  end

  describe "#formatted_submission_date" do
    context "when there is a date" do
      before do
        @sba_application.application_submitted_at = Date.parse("25-12-2000")
      end

      it 'should be properly formatted' do
        expect(@sba_application.formatted_submission_date).to eq("12/25/2000")
      end
    end

    context "when there is not a date" do
      before do
        @sba_application.application_submitted_at = nil
      end

      it 'should be nil' do
        expect(@sba_application.formatted_submission_date).to be_nil
      end
    end
  end

  context "when this is the first version (not returned)" do
    before do
      @sba_application.version_number = 1
    end

    describe "#returned?" do
      it 'should be false' do
        expect(@sba_application).not_to be_returned
      end
    end

    describe "#deleteable?" do
      it 'should be true' do
        expect(@sba_application).to be_deleteable
      end
    end
  end

  context "when this is NOT the first version (has been returned)" do
    before do
      @sba_application.version_number = 2
    end

    describe "#returned?" do
      it 'should be true' do
        expect(@sba_application).to be_returned
      end
    end

    describe "#deleteable?" do
      it 'should be false' do
        expect(@sba_application).not_to be_deleteable
      end
    end
  end


  describe "#clear_servicing_bos" do
    before do
      @certificate = build(:certificate_eight_a)
      @sba_application = create(:eight_a_display_application_initial)
      @certificate.sba_applications << @sba_application
      @user = create(:user_random)
      @certificate.servicing_bos = @user
      @certificate.save!
    end

    context "before app clears the servicing bos" do
      it "should be same user" do
        expect(@certificate.servicing_bos.id).to eq(@user.id)
      end
    end

    context "after app clears the servicing bos" do
      before do
        @sba_application.clear_servicing_bos
      end
      it "should be nil" do
        expect(@sba_application.certificate.servicing_bos).to be_nil
      end
    end
  end

  describe "#servicing_bos_name" do
    before do
      @certificate = build(:certificate_eight_a)
      @sba_application = create(:eight_a_display_application_initial)
      @certificate.sba_applications << @sba_application
      @user = create(:user_random)
      @certificate.servicing_bos = @user
      @certificate.save!
    end

    context "if certificate exists" do
      it "should return user name" do
        expect(@sba_application.servicing_bos_name).to eq(@user.name)
      end
    end

    context "if certificate is nil" do
      before do
        @sba_application.certificate = nil
      end
      it "should return 'None'" do
        expect(@sba_application.servicing_bos_name).to eq('None')
      end
    end
  end

  describe "#has_active_certificate?" do
    before do
      @certificate = build(:certificate_eight_a)
      @sba_application = create(:eight_a_display_application_initial)
      @certificate.sba_applications << @sba_application
      @certificate.workflow_state
      @certificate.save!
    end

    context "if certificate is nil" do
      before do
        @sba_application.certificate = nil
      end
      it "should return false" do
        expect(@sba_application.has_active_certificate?).to be_falsey
      end
    end

    context "if certificate exists and is ineligible" do
      before do
        @sba_application.certificate.update(workflow_state: 'ineligible')
      end
      it "should return true" do
        expect(@sba_application.has_active_certificate?).to be_truthy
      end
    end

    context "if certificate exists and is ineligible" do
      before do
        @sba_application.certificate.update(workflow_state: 'ineligible')
      end
      it "should return true" do
        expect(@sba_application.has_active_certificate?).to be_truthy
      end
    end

    context "if certificate exists and is pending" do
      before do
        @sba_application.certificate.update(workflow_state: 'pending')
      end
      it "should return true" do
        expect(@sba_application.has_active_certificate?).to be_truthy
      end
    end

    context "if certificate exists and is active" do
      before do
        @sba_application.certificate.update(workflow_state: 'active')
      end
      it "should return true" do
        expect(@sba_application.has_active_certificate?).to be_truthy
      end
    end
  end

  describe "#duty_station_id" do
    context "when there are no duty stations" do
      it 'should return nil' do
        expect(@sba_application.duty_station_id).to be_nil
      end
    end
  end

  describe "#duty_station_name" do
    before do
      @certificate = build(:certificate_eight_a)
      @sba_application = create(:eight_a_display_application_initial)
      @certificate.sba_applications << @sba_application
      @certificate.save!
      @dt_sf = DutyStation.find_by(name: 'San Francisco')
    end

    context "if no duty station exists" do
      it "should return 'None'" do
        expect(@sba_application.duty_station_name).to eq('None')
      end
    end

    context "if duty station exists" do
      before do
        @certificate.duty_station = @dt_sf
        @certificate.save!
      end
      it "should return duty station name" do
        expect(@sba_application.duty_station_name).to eq('San Francisco')
      end
    end
  end

end
