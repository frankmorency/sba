require 'rails_helper'

RSpec.describe SbaApplication::SubApplication, type: :model do
  it { is_expected.to validate_presence_of(:master_application_id) }

  describe "#master_application" do
    before do
      @app = SbaApplication::SubApplication.new
    end

    it 'should behave like belong_to' do
      expect(SbaApplication).to receive(:find).with(@app.master_application_id).and_return(nil)
      @app.master_application
    end
  end

  describe "#master_application=" do
    before do
      @app = SbaApplication::SubApplication.new
    end

    it 'should behave like belong_to' do
      expect(@app).to receive(:master_application_id=).with(26)
      @app.master_application= double(SbaApplication::MasterApplication, id: 26)
    end
  end

  describe "#drafty?" do
    before do
      @app = SbaApplication::SubApplication.new
      allow(@app).to receive(:status).and_return('Sadlfkajsdlf')
    end

    it "should return true" do
      expect(@app).to be_drafty
    end

    context "when the app is complete" do
      before do
        allow(@app).to receive(:status).and_return(Section::COMPLETE)
      end

      it "should reopen the sub app" do
        expect(@app).to receive(:reopen!).and_return true
        expect(@app.drafty?).to be_truthy
      end
    end
  end

  describe "#complete?" do
    before do
      @app = SbaApplication::SubApplication.new
    end

    context "when the status is complete" do
      before do
        allow(@app).to receive(:status).and_return(Section::COMPLETE)
      end

      it "should return true" do
        expect(@app).to be_complete
      end
    end

    context "when the status is not complete" do
      before do
        allow(@app).to receive(:status).and_return('Sadlfkajsdlf')
      end

      it "should return true" do
        expect(@app).not_to be_complete
      end
    end
  end

  describe "#reconsideration_or_appeal_deadline_passed?" do
    before do
      @app = SbaApplication::SubApplication.new
      @review = create(:review, :skip_validate)
      @review.sba_application = @app
      @review.save(validate: false)

      allow(@app).to receive(:current_review).and_return @review
    end

    context "when the deadline has not been passed" do
      before do
        @review.update(reconsideration_or_appeal_clock: Date.today)
      end

      it "should return false" do
        expect(@app.reconsideration_or_appeal_deadline_passed?).to eq(false)
      end
    end

    context "when the deadline has been passed" do
      before do
        @review.update(reconsideration_or_appeal_clock: DateTime.new(2018, 11, 6))
      end

      it "should return true" do
        expect(@app.reconsideration_or_appeal_deadline_passed?).to eq(true)
      end
    end

    context "when reconsideration due on first day of gov shutdown" do
      before do
        @review.update(reconsideration_or_appeal_clock: DateTime.new(2018, 11, 7))
      end

      it "should return true" do
        expect(@app.reconsideration_or_appeal_deadline_passed?).to eq(false)
      end
    end

    context "when reconsideration due on last day of gov shutdown" do
      before do
        @review.update(reconsideration_or_appeal_clock: DateTime.new(2018, 12, 22))
      end

      it "should return true" do
        expect(@app.reconsideration_or_appeal_deadline_passed?).to eq(false)
      end
    end

  end

  describe "#current_responsible_party" do
    before do
      @app = SbaApplication::SubApplication.new
    end

    context "when in draft workflow state" do
      it "should return Firm" do
        expect(@app.current_responsible_party).to match("Firm")
      end
    end

    context "when in submitted workflow state" do
      before do
        @app.workflow_state = "submitted"
      end
      it "should return SBA" do
        expect(@app.current_responsible_party).to match("SBA")
      end
    end
  end

end
