require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

RSpec.describe Questionnaire::EightAAnnualReview, type: :model do
  xdescribe ".create_application!(org)" do
    before do
      @analyst = create(:eight_a_cods_analyst_user)
      @org = create(:org_with_user)
      load_sample_questionnaire('eight_a_annual_review')
    end

    describe "8a certificate was reviewed in January of this year and this is December" do

      before do
        user = @org.users.first
        cert_type = CertificateType::EightA.first
        @cert = create(:certificate_eight_a_initial, workflow_state: 'active',
                                                     organization_id: @org.id,
                                                     certificate_type: cert_type)
        this_january = Date.new(Date.today.year, 1, 1)
        @cert.update_attributes(issue_date: this_january)
        @this_december = Date.new(Date.today.year, 12, 1)
        travel_to @this_december do
          annual_review = Questionnaire::EightAAnnualReview.create_application!(@org)
        end
      end

      it 'creates annual review and sends reminder email' do
        next_january = Date.new(Date.today.next_year.year, 1, 1)
        expect(@cert.current_application.review_for).to eq( next_january)
        expect(@cert.current_application.type).to eq('SbaApplication::EightAAnnualReview')
      end
    end

    context "when there is an active certificate" do
      before do
        @cert = create(:certificate_eight_a_initial, workflow_state: 'active', organization_id: @org.id, certificate_type: CertificateType::EightA.first, issue_date: 1.year.ago)
      end

      context "when it's been 8 years since the date of issue" do
        before do
          @cert.update_attribute(:issue_date, 8.years.ago)
          @annual_review = Questionnaire::EightAAnnualReview.create_application!(@org)
        end

        it 'should return a new application' do
          expect(@annual_review).to be_a(SbaApplication::EightAAnnualReview)
          expect(@annual_review).to be_persisted
          expect(@annual_review).to be_draft
        end
      end

      context "when it's been over 10 years since date of issue" do
         before do
           @cert.update_attribute(:issue_date, 121.months.ago)
         end

         it 'should raise an error' do
           expect { Questionnaire::EightAAnnualReview.create_application!(@org) }.to raise_error("No more annual reviews available for for this certificate")
         end
      end

      context "when there is a review for last year" do
        before do
          @cert.update_attribute(:issue_date, 1.years.ago.to_date)
          old_review = Questionnaire::EightAAnnualReview.create_application!(@org) # create this year's review
          @cert.update_attribute(:issue_date, 2.years.ago.to_date)
          old_review.update_attributes(review_for: 1.years.ago.to_date, review_number: 1)
          @annual_review = Questionnaire::EightAAnnualReview.create_application!(@org)
        end

        it 'should create a new annual review for this year' do
          expect(@annual_review.review_for).to eq(Date.today)
          expect(@annual_review.review_number).to eq(2)
        end
      end

      context "when there are no previous reviews" do
        before do
          @annual_review = Questionnaire::EightAAnnualReview.create_application!(@org)
        end

        it 'should return a new application' do
          expect(@annual_review).to be_a(SbaApplication::EightAAnnualReview)
          expect(@annual_review).to be_persisted
          expect(@annual_review).to be_draft
        end

        it 'should set the review_for date to a year since the Certificate#issue_date' do
          expect(@annual_review.review_for).to eq((@cert.issue_date + 1.year).to_date)
        end

        describe "and then submitting it" do
          it 'should not (re)activate the certificate' do
            expect(@cert).not_to receive(:activate!)
            @annual_review.submit!
          end

          it 'should set the screening due date the same as an initial application' do
            @annual_review.submit!
            expect(@annual_review.screening_due_date).to eq(15.days.from_now.to_date)
          end

          describe "and assigning it" do
            before do
              @annual_review.submit!
              @review = Review::EightAInitial.create_and_assign_review(@analyst, @annual_review)
            end

            it 'should create a review assigned to this application in "screening"' do
              expect(@review.sba_application).to eq(@annual_review)
              expect(@review).to be_screening
              expect(@review.certificate).to eq(@cert)
            end

            it 'should also set the screening due date' do
              expect(@review.screening_due_date).to eq(15.days.from_now.to_date)
            end

            it 'should still have an active cert' do
              expect(@cert).to be_persisted
              expect(@cert).to be_active
            end

            describe "and doing a 'full return'" do
              before do
                @annual_review.full_return!({}, @analyst)
              end

              it 'should delete the review' do
                expect(Review.count).to be(0)
              end

              it 'should set the app to "returned"' do
                expect(@annual_review).to be_persisted
                expect(@annual_review).to be_returned
              end

              it 'should still have an active cert' do
                expect(@cert).to be_persisted
                expect(@cert).to be_active
              end

              it 'should clear the submitted and screening_due dates' do
                expect(@annual_review.application_submitted_at).to eq(nil)
                expect(@annual_review.screening_due_date).to eq(nil)
              end
            end

            describe "and doing a 'deficiency letter' return" do
              before do
                @annual_review.deficiency_letter_return!({}, @analyst)
              end

              it 'should NOT delete the review' do
                expect(@review).not_to be_nil
                expect(Review.count).to be(1)
              end

              it 'should set the app to "returned"' do
                expect(@annual_review).to be_persisted
                expect(@annual_review).to be_returned
              end

              it 'should still have an active cert' do
                expect(@cert).to be_persisted
                expect(@cert).to be_active
              end

              it 'should clear the submitted_at date' do
                expect(@annual_review.application_submitted_at).to eq(nil)
              end

              it 'should clear the submitted and screening_due dates' do
                expect(@annual_review.reload.application_submitted_at).to eq(nil)
                expect(@annual_review.reload.screening_due_date).to eq(nil)
                expect(@review.reload.screening_due_date).to eq(nil)
              end

              it 'should set the letter_due_date to 10 days from now' do
                expect(@review.reload.letter_due_date).to eq(10.days.from_now.to_date)
              end
            end


            describe "and doing a 'fifteen-day return'" do
              it 'should raise an error' do
                expect { @annual_review.fifteen_day_return!({}, @analyst) }.to raise_error(/15 day returns can only be made on initial/)
              end
            end
          end
        end
      end
    end

    context "when there is no certificate" do
      it 'should raise an error' do
        expect { Questionnaire::EightAAnnualReview.create_application!(@org) }.to raise_error("You must have an active 8(a) certificate to start an annual review")
      end
    end

    context "when there is a non-active certificate" do
      before do
        @eight_a_certs = double
        allow(@org).to receive(:certificates).and_return(@eight_a_certs)
        allow(@eight_a_certs).to receive(:eight_a).and_return([double(:"active?" => false)])
      end

      it 'should raise an error' do
        expect { Questionnaire::EightAAnnualReview.create_application!(@org) }.to raise_error("You must have an active 8(a) certificate to start an annual review")
      end
    end
  end

  describe "#start_application(org)" do
    before do
      @org = create(:org_with_user)
      @questionnaire = Questionnaire::EightAAnnualReview.new
    end

    context "when there is an active certificate" do
      before do
        @cert = create(:certificate_eight_a_initial, workflow_state: 'active', organization_id: @org.id)
      end

      it 'should return a new application' do
        expect(@questionnaire.start_application(@org)).to be_a(SbaApplication::EightAAnnualReview)
      end
    end

    context "when there is no certificate" do
      it 'should raise an error' do
        expect { @questionnaire.start_application(@org) }.to raise_error("You must have an active 8(a) certificate to start an annual review")
      end
    end

    context "when there is a non-active certificate" do
      before do
        @eight_a_certs = double
        allow(@org).to receive(:certificates).and_return(@eight_a_certs)
        allow(@eight_a_certs).to receive(:eight_a).and_return([double(:"active?" => false)])
      end

      it 'should raise an error' do
        expect { @questionnaire.start_application(@org) }.to raise_error("You must have an active 8(a) certificate to start an annual review")
      end
    end
  end
end
