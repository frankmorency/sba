require 'rails_helper'

RSpec.describe SbaApplication::EightAAnnualReview, type: :model do
  before do
    @org = create(:org_with_user)
    @cert_type = CertificateType::EightA.first
    @cert = create(:certificate_eight_a_initial, workflow_state: 'active', organization_id: @org.id, certificate_type: @cert_type)

    @annual_review = SbaApplication::EightAAnnualReview.new(certificate: @cert, organization: @org)
  end

  describe "#set_review" do
    context "and the certificate was issued over 9 years ago" do
      before do
        @cert.update_attribute(:issue_date, 121.months.ago)
      end

      xit 'should raise an error' do
        expect {@annual_review.send :set_review}.to raise_error("No more annual reviews available for for this certificate")
      end
    end

    xcontext "and the certificate was issued exactly 8 years ago" do
      before do
        @cert.update_attribute(:issue_date, 8.years.ago)
        @annual_review.send :set_review
      end

      it 'should set the review for next month' do
        expect(@annual_review.review_for).to eq(Date.today)
      end

      it 'should set the review number to 8' do
        expect(@annual_review.review_number).to eq(8)
      end
    end

    xcontext "and the certificate was issued 7 years and 11 months ago" do
      context "without annual review history" do
        before do
          @cert.update_attribute(:issue_date, 96.months.ago)
          @annual_review.send :set_review
        end

        it 'should set the review for next month' do
          expect(@annual_review.review_for).to eq(Date.today)
        end

        it 'should set the review number to 8' do
          expect(@annual_review.review_number).to eq(8)
        end
      end


    context "and the certificate was issued 7 years and 11 months ago" do
#  Seems to fail in December JJ
#       context "without annual review history" do
#           before do
#             @cert.update_attribute(:issue_date, 95.months.ago)
#             @annual_review.send :set_review
#           end

#           it 'should set the review for next month' do
#             expect(@annual_review.review_for).to eq(1.month.from_now.to_date)
#           end

#           it 'should set the review number to 8' do
#             expect(@annual_review.review_number).to eq(8)
#           end
#         end

        context "with annual review history" do
          before do
            @cert.update_attribute(:issue_date, 7.years.ago - 11.months)
            fake = double
            allow(fake).to receive(:maximum).and_return 7
            allow(@cert).to receive(:sba_applications).and_return fake
            allow(@annual_review).to receive(:last_review_date).and_return 11.months.ago.to_date
            @annual_review.send :set_review
          end

          # TODO: review why the skipped tests were failing when enabled
          xit 'should set the review for next month' do
            expect(@annual_review.review_for).to eq(1.month.from_now.to_date)
          end

          xit 'should set the review number to 8' do
            expect(@annual_review.review_number).to eq(8)
          end
        end
      end
    end

    xcontext "and the certificate was issued 7 years and 10 months ago" do
      before do
        @cert.update_attribute(:issue_date, 94.months.ago)
        @annual_review.send :set_review
      end

      it 'should invalidate the review' do
        expect(@annual_review).not_to be_valid
        expect(@annual_review.errors[:review_number]).to include("is not due yet")
      end
    end

    # TODO - These checks need to be revisited
    # context "and the certificate was issued 25 months ago" do
    #   before do
    #     @cert.update_attribute(:issue_date, 25.months.ago)
    #     @annual_review.send :set_review
    #   end
    #
    #   it 'should invalidate the review' do
    #     expect(@annual_review).not_to be_valid
    #     #expect(@annual_review.errors[:review_number]).to include("is not due yet")
    #   end
    # end
    #
    # context "and the certificate was issued 24 months ago" do
    #   before do
    #     @cert.update_attribute(:issue_date, 24.months.ago)
    #     @annual_review.send :set_review
    #   end
    #
    #   it 'should set the review for 11 months from now' do
    #     expect(@annual_review.review_for).to eq(Date.today)
    #   end
    #
    #   it 'should set the review number to 2' do
    #     expect(@annual_review.review_number).to eq(2)
    #   end
    # end

    context "and the certificate was issued 23 months ago" do
      before do
        @cert.update_attribute(:issue_date, 23.months.ago)
      end

      context "and there are no previous annual reviews" do
        before do
          @annual_review.send :set_review
        end

        # TODO: review why the skipped tests were failing when enabled
        xit 'should set the review for 1 month from now' do
          expect(@annual_review.review_for).to eq(1.month.from_now.to_date)
        end

        xit 'should set the review number to 2' do
          expect(@annual_review.review_number).to eq(2)
        end
      end

      context "and there is ONE previous annual review" do
        before do
          fake = double
          allow(fake).to receive(:maximum).and_return 1
          allow(@cert).to receive(:sba_applications).and_return fake
          @annual_review.send :set_review
        end

        # TODO: review why the skipped tests were failing when enabled
        xit 'should set the review for 1 month from now' do
          expect(@annual_review.review_for).to eq(1.month.from_now.to_date)
        end

        xit 'should set the review number to 2' do
          expect(@annual_review.review_number).to eq(2)
        end
      end
    end

    xcontext "and the certificate was issued 13 months ago" do
      before do
        # Resolve edge case where 13.months.ago is on Feb 29th.
        date_for_test = 13.months.ago
        if ((13.months.ago).to_s.include? "-02-29")
          date_for_test = 13.months.ago - 1.day
        end
        @cert.update_attribute(:issue_date, date_for_test)
        @annual_review.send :set_review
      end

      it 'should invalidate the review' do
        expect(@annual_review).not_to be_valid
        #expect(@annual_review.errors[:review_number]).to include("is not due yet")
      end
    end

    xcontext "and the certificate was issued 1 year ago" do
      before do
        @cert.update_attribute(:issue_date, 12.months.ago)
        @annual_review.send :set_review
      end

      context "and there's no previous annual review" do
        before do
          @annual_review.send :set_review
        end

        it 'should set the review for today' do
          expect(@annual_review.review_for).to eq(Date.today)
        end

        it 'should set the review number to 1' do
          expect(@annual_review.review_number).to eq(1)
        end
      end

      context "and there is ONE previous annual review" do
        before do
          fake = double
          allow(fake).to receive(:maximum).and_return 1
          allow(@cert).to receive(:sba_applications).and_return fake
          allow(@annual_review).to receive(:last_review_date).and_return 1.month.ago.to_date
          @annual_review.send :set_review
        end

        it 'should invalidate the review' do
          expect(@annual_review).not_to be_valid
          expect(@annual_review.errors[:review_number]).to include("is not due yet")
        end
      end
    end


    context "and the certificate was issued 11 months ago" do
      before do
        @cert.update_attribute(:issue_date, 11.months.ago)
        @annual_review.send :set_review
      end

      # TODO: review why the skipped tests were failing when enabled
      xit 'should set the review for 1 month from now' do
        expect(@annual_review.review_for).to eq(1.month.from_now.to_date)
      end

      xit 'should set the review number to 1' do
        expect(@annual_review.review_number).to eq(1)
      end
    end

    xcontext "and the certificate was issued 10 months ago" do
      before do
        @cert.update_attribute(:issue_date, 10.months.ago)
        @annual_review.send :set_review
      end

      it 'should invalidate the review' do
        expect(@annual_review).not_to be_valid
        expect(@annual_review.errors[:review_number]).to include("is not due yet")
      end
    end

    xcontext "and the certificate was issued 1 month ago" do
      before do
        @cert.update_attribute(:issue_date, 1.month.ago)
        @annual_review.send :set_review
      end

      it 'should invalidate the review' do
        expect(@annual_review).not_to be_valid
        expect(@annual_review.errors[:review_number]).to include("is not due yet")
      end
    end
  end
end
