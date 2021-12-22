require 'rails_helper'

RSpec.describe Certificate, type: :model do
  it { is_expected.to have_many(:workflow_changes) }
  it { is_expected.to belong_to(:certificate_type) }
  it { is_expected.to belong_to(:organization) }
  it { is_expected.to have_many(:annual_review_applications) }

  before do
    @certificate_type = load_sample_questionnaire

    @user = vendor_user

    @app = Spec::Fixtures::SampleApplication.load(@user, @certificate_type, :draft)
    allow(@app.organization).to receive(:legal_business_name).and_return("The Company")
  end

  describe "when creating a WOSB program certificate" do
    context "on valid state" do
      before do
        @certificate = @app.submit!
        @app.save!
      end

      it "should create successfully with a valid application" do
        expect(@certificate.valid?).to eq(true)
      end

      it "should fail if certificate already exists" do
        expect { @app.submit! }.to raise_error(Workflow::NoTransitionAllowed)
      end

      it "should associate to an application" do
        expect(@certificate.current_application.id).to eq(@app.id)
      end

      it "should set status correctly" do
        expect(@certificate.active?).to be_truthy
      end

      it 'should set decision correctly' do
        expect(@certificate.decision).to eq('Self Certified')
      end

      it "should transition to the active state directly" do
        expect(@certificate.workflow_state).to eq('active')
      end

      it "should have non-nil expiry date" do
        expect(@certificate.expiry_date).to be_truthy
      end
    end
  end

  describe "when looking for non-expired certificates" do
    before do
      @initial_count = Certificate.not_expired.count
      @app.certificate_type.update_attributes type: 'CertificateType::Mpp', duration_in_days: 365
      @app.questionnaire.update_attributes maximum_allowed: 2
      @certificate = @app.submit!
    end

    context "with expired certificates" do
      before do
        @certificate.update!(:expiry_date => 1.week.ago)
      end

      it "should find none" do
        expect(Certificate.not_expired.count).to eq(@initial_count)
      end
    end

    context "with unexpired certificates" do
      before do
        @certificate.update!(:expiry_date => 1.week.from_now)
      end

      it "should find one" do
        expect(Certificate.not_expired.count).to eq(@initial_count + 1)
      end
    end
  end

  describe "#clear_servicing_bos" do
    before do
      @certificate = @app.submit!
      @user = create(:user_random)
    end

    context "after setting the servicing bos" do
      before do
        @certificate.servicing_bos = @user
      end
      it "should be same user" do
        expect(@certificate.servicing_bos.id).to eq(@user.id)
      end
    end

    context " after clearing the servicing bos" do
      before do
        @certificate.clear_servicing_bos
      end
      it "should be nil" do
        expect(@certificate.servicing_bos).to be_nil
      end
    end
  end

  describe "#servicing_bos_name" do
    before do
      @certificate = @app.submit!
      @user = create(:user_random)
    end

    context "if servicing bos exists" do
      before do
        @certificate.servicing_bos = @user
      end
      it "should return user name" do
        expect(@certificate.servicing_bos_name).to eq(@user.name)
      end
    end

    context "if servicing bos is nil" do
      before do
        @certificate.clear_servicing_bos
      end
      it "should return 'None'" do
        expect(@certificate.servicing_bos_name).to eq('None')
      end
    end
  end



  describe "when Faking an MPP application for transition" do
    context "on valid state" do
      before do
        # Making it an mpp application. ( conceptualy )
        @app.certificate_type.update_attributes type: 'CertificateType::Mpp', duration_in_days: 365
        @app.questionnaire.update_attributes maximum_allowed: 2
        @certificate = @app.submit!
        @app.save!
      end

      it "should trnasition to the pending state directly" do
        expect(@certificate.workflow_state).to eq('pending')
      end

      it "should be in an active state" do
        expect(Certificate.with_active_state.order(created_at: :desc).first).to eq @certificate
      end

      it "should have nil issue date" do
        expect(@certificate.issue_date).to be_nil
      end

      it "should have nil expiry date" do
        expect(@certificate.expiry_date).to be_nil
      end
    end
  end

  describe "when certificate review_closed" do
    let(:eighta_review) { Review::EightAAnnualReview.new(certificate: FactoryBot.create(:eight_a_certificate_determination)) }

    before do
      eighta_review.certificate.review_closed!
    end

    it "should have a workflow_state of closed" do
      expect(eighta_review.certificate.workflow_state).to eq('closed')
    end
  end
end
