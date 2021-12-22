require 'rails_helper'

RSpec.describe SbaApplication::MasterApplication, type: :model do
  describe "#unassigned_cases" do
    before do
      @initial_only = double()
      @non_bdmis = double()
      @not_in_review = double()
      @with_valid_cert = double()
    end

    it 'should not include apps with certs in a terminal state' do
      expect(SbaApplication::MasterApplication).to receive(:where).with(kind: SbaApplication::INITIAL).and_return(@initial_only)
      expect(@initial_only).to receive(:where).with(bdmis_case_number: nil).and_return(@non_bdmis)
      expect(@non_bdmis).to receive(:not_in_review).and_return(@not_in_review)
      expect(@not_in_review).to receive(:with_valid_cert).and_return(@with_valid_cert)
      allow(@with_valid_cert).to receive(:order)

      SbaApplication::MasterApplication.unassigned_cases
    end
  end
  
  describe "#assign_duty_station_to_app" do
    before do
      @dt_sf = DutyStation.find_by(name: 'San Francisco')
      @certificate = build(:certificate_eight_a)
      @sba_application = create(:eight_a_display_application_initial)
      @certificate.sba_applications << @sba_application
      @certificate.save!
    end

    context "after duty station is assigned" do
      before do
        @sba_application.assign_duty_station_to_app(@dt_sf)
      end

      it "should have only one duty station" do
        expect(@sba_application.duty_stations.length).to eq(1)
      end

      it "should be the duty station that was passed in" do
        expect(@sba_application.duty_stations.first.name).to eq('San Francisco')
      end

      it "associated certificate should be assigned the same duty station" do
        expect(@sba_application.certificate.duty_station.name).to eq('San Francisco')
      end
    end
  end

  describe "assign_servicing_bos_to_certificate" do
    before do
      @certificate = build(:certificate_eight_a)
      @sba_application = create(:eight_a_display_application_initial)
      @certificate.sba_applications << @sba_application
      @user = create(:user_random)
      @certificate.save!
    end

    context "after servicing bos is assigned" do
      before do
        @sba_application.assign_servicing_bos_to_certificate(@user)
      end

      it "should be the servicing bos that was passed in" do
        expect(@sba_application.certificate.servicing_bos.id).to eq(@user.id)
      end
    end
  end

  describe "#card_title" do
    before do
      @sba_application = create(:eight_a_display_application_initial, workflow_state: 'draft')
      @eight_a_cert = create(:certificate_eight_a)
      @sba_application.update_attribute(:certificate_id, @eight_a_cert)
      @sba_application.save(validate: false)

      @review = create(:review_for_eight_a)
      @review.sba_application = @sba_application
      @review.save(validate: false)

      allow(@sba_application).to receive(:current_review).and_return @review

      @master_section = build(:master_section_2)
      @master_section.save

      @section_1 = build(:reconsideration_section_1)
      @section_2 = build(:reconsideration_section_2)
      @section_3 = build(:reconsideration_section_3)

      @question_section = build(:section_1)
    end

    context "when section is not ReconsiderationSection" do
      it "should return section title" do
        expect(@sba_application.card_title(@question_section)).to eq(@question_section.title)
      end
    end

    context "when review workflow state is pending_reconsideration_or_appeal" do
      before do
        @review.workflow_state = "pending_reconsideration_or_appeal"
        @review.save
        @sba_application.sections << @master_section
        @sba_application.sections << @section_1
        @section_1.update_attribute(:parent, @master_section)
      end

      it "should return Reconsideration or Appeal" do
        expect(@sba_application.card_title(@section_1)).to eq('Reconsideration or Appeal')
      end
    end

    context "when review workflow state is appeal" do
      before do
        @review.workflow_state = "appeal_intent"
        @review.save
        @sba_application.sections << @master_section
        @sba_application.sections << @section_1
        @section_1.update_attribute(:parent, @master_section)
      end

      it "should return Appeal" do
        expect(@sba_application.card_title(@section_1)).to eq('Intent to Appeal')
      end
    end

    context "when review is nil" do
      before do
        @review = nil
        @sba_application.sections << @master_section
        @sba_application.sections << @section_1
        @section_1.update_attribute(:parent, @master_section)
      end

      it "should return section title" do
        expect(@sba_application.card_title(@section_1)).to eq(@section_1.title)
      end
    end

    context "when section is not the last ReconsiderationSection" do
      before do
        @review.workflow_state = "pending_reconsideration_or_appeal"
        @review.save
        @sba_application.sections << @master_section
        @sba_application.sections << @section_1
        @sba_application.sections << @section_2
        @sba_application.sections << @section_3
        @section_1.update_attribute(:parent, @master_section)
        @section_2.update_attribute(:parent, @master_section)
        @section_3.update_attribute(:parent, @master_section)
      end

      it "should return section title" do
        expect(@sba_application.card_title(@section_1)).to eq(@section_1.title)
      end
    end
  end

  describe "#drafty?" do
    before do
      @app = SbaApplication::EightAMaster.new
    end

    context "when the app is in draft state" do
      before do
        @app.workflow_state = "draft"
      end

      it "should return true" do
        expect(@app).to be_drafty
      end
    end

    context "when the app is in a returned state" do
      before do
        @app.workflow_state = "returned"
      end

      it "should return true" do
        expect(@app).to be_drafty
      end
    end

    context "when the app is not in draft state" do
      before do
        @app.workflow_state = "submitted"
      end

      it "should return false" do
        expect(@app).not_to be_drafty
      end
    end
  end
end
