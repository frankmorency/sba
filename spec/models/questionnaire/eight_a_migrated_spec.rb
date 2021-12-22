require 'rails_helper'

RSpec.describe Questionnaire::EightAMigrated, type: :model do
  describe "load_from_csv!" do
    before do
      @bad_duns = '595237256'

      allow(Signature).to receive(:new).and_return double(terms: [double(process: 'term 1')])

      allow(MvwSamOrganization).to receive(:get).with(any_args) do |duns|
        MvwSamOrganization.new(duns: duns, tax_identifier_type: "EIN", tax_identifier_number: duns)
      end

      @directory = 'spec/fixtures/bdmis_test/success_case'

      #Setup Duty Station needed by the migration
      [["San Francisco",1],
       ["Philadelphia",1]].each do |couple|
        DutyStation.create!(name: couple[0], region_code: couple[1])
      end

    end

    context "without any issues" do
      before do
        @return_value = Questionnaire::EightAMigrated.load_from_csv!(@directory)
      end

      it 'should not raise any errors' do
        expect(@return_value).to be_nil
      end

      it 'should update the bdmis_migrations table with the application ids' do
        expect(BdmisMigration.count).to be(6)
        expect(BdmisMigration.pluck(:error_messages).join).to eq('')
        expect(BdmisMigration.where(error_messages: nil).count).to be(6)
        expect(BdmisMigration.where(sba_application_id: nil).count).to be(0)
      end
    end

    # DOUBLE CHECK 2 APPROVAL DATES?
    # null in fields?
    # should not be able to start another application
    # should not displaying in view as BDMIS Archive
    # more data problem tests...

    describe "model generation" do
      context "with all data fields in the csv" do
        before do
          @directory = 'spec/fixtures/bdmis_test/model_test'
          @return_value = Questionnaire::EightAMigrated.load_from_csv!(@directory)

          @master_application = Questionnaire.find_by(name: 'eight_a_migrated').sba_applications.first
        end

        describe "master_application" do
          it 'should be "submitted"' do
            expect(@master_application).to be_submitted
          end

          describe "#link_label" do
            it "should be 'BDMIS Archive'" do
              expect(@master_application.link_label).to eq('BDMIS Archive')
            end
          end

          describe "#application_submitted_at" do
            it 'should be set to the "submitted_on_date" field' do
              expect(@master_application.application_submitted_at.to_date).to eq(Chronic.parse("6/19/08").to_date)
            end
          end

          describe "#creator" do
            it 'should be nil' do
              expect(@master_application.creator).to be_nil
            end
          end
        end

        describe "sub_application" do
          it 'the can only be one' do
            expect(@master_application.sub_applications.count).to eq(1)
          end

          it 'should be "complete"' do
            expect(@master_application.sub_applications.first.section.status).to eq('COMPLETE')
          end
        end

        describe "certificate" do
          it 'should be "active"' do
            expect(@master_application.certificate.workflow_state).to eq('active')
          end

          describe "#issue_date" do
            it 'should be set to "approved_date" field' do
              expect(@master_application.certificate.issue_date).to eq(Chronic.parse("01/21/09"))
            end
          end

          describe "#expiry_date" do
            it 'should be set to the "exit_date" field' do
              expect(@master_application.certificate.expiry_date).to eq(Chronic.parse("01/21/18"))
            end
          end

          describe "#next_annual_report_date" do
            it 'should be set to the "next_review" field' do
              expect(@master_application.certificate.next_annual_report_date.to_date).to eq(Chronic.parse("01/21/17").to_date)
            end
          end
        end
      end

      context "with none of the dates in the csv" do
        before do
          @directory = 'spec/fixtures/bdmis_test/model_test_blank'
          @return_value = Questionnaire::EightAMigrated.load_from_csv!(@directory)

          @master_application = Questionnaire.find_by(name: 'eight_a_migrated').sba_applications.first
        end

        describe "master_application" do
          it 'should be "submitted"' do
            expect(@master_application).to be_submitted
          end

          describe "#link_label" do
            it "should be 'BDMIS Archive'" do
              expect(@master_application.link_label).to eq('BDMIS Archive')
            end
          end

          describe "#application_submitted_at" do
            it 'should be set to today' do
              expect(@master_application.application_submitted_at.to_date).to eq(Time.now.utc.to_date)
            end
          end
        end

        describe "sub_application" do
          it 'the can only be one' do
            expect(@master_application.sub_applications.count).to eq(1)
          end
          it 'should be "complete"' do
            expect(@master_application.sub_applications.first.section.status).to eq('COMPLETE')
          end
        end

        describe "certificate" do
          it 'should be "active"' do
            expect(@master_application.certificate).to be_active
          end

          describe "#issue_date" do
            it 'should be nil' do
              expect(@master_application.certificate.issue_date).to be_nil
            end
          end

          describe "#expiry_date" do
            it 'should be nil' do
              expect(@master_application.certificate.expiry_date).to be_nil
            end
          end

          describe "#next_annual_report_date" do
            it 'should be nil' do
              expect(@master_application.certificate.next_annual_report_date).to be_nil
            end
          end
        end
      end    end

    context "when there's a problem parsing the file" do
      before do
        @directory = 'spec/fixtures/bdmis_test/botched_file'
      end

      it 'should raise an error' do
        expect { Questionnaire::EightAMigrated.load_from_csv!(@directory) }.to raise_error(/Invalid business\.csv format/)
      end
    end

    context "when the org is not found in SAM" do
      before do
        allow(MvwSamOrganization).to receive(:get).with('582976669').and_return nil

        @return_value = Questionnaire::EightAMigrated.load_from_csv!(@directory)
        @bad_record = BdmisMigration.find_by(duns: '582976669')
      end

      it 'should not raise any errors' do
        expect(@return_value).to be_nil
      end

      it 'should update the bdmis_migrations table with the other applications' do
        expect(BdmisMigration.count).to be(6)
        expect(BdmisMigration.where(error_messages: nil).count).to be(5)
        expect(BdmisMigration.where(sba_application_id: nil).count).to be(1)
      end

      it "should log an error in the BDMIS table" do
        expect(@bad_record.error_messages).to match(/No record found in SAM database for DUNS: 582976669/)
      end

      it "should not have an app id" do
        expect(@bad_record.sba_application_id).to be_nil
      end

      it "should have the correct duns" do
        expect(@bad_record.duns).to eq('582976669')
      end
    end

    context "when there's already a cert in the system" do
      context "and it's the 8(a) interim" do
        it 'should delete it and continue on to create the archive' do

        end
      end

      context "and it's the full 8(a) initial" do
        # log error...
      end
    end

    context "when the master application fails to save" do
      before do
        @directory = 'spec/fixtures/bdmis_test/one_bad_apple'

        allow_any_instance_of(SbaApplication::EightAMaster).to receive(:save!).and_raise("This is my error")

        @return_value = Questionnaire::EightAMigrated.load_from_csv!(@directory)
        @bad_record = BdmisMigration.find_by(duns: @bad_duns)
      end

      it 'should not raise any errors' do
        expect(@return_value).to be_nil
      end

      it "should log an error in the BDMIS table" do
        expect(BdmisMigration.count).to be(1)
        expect(@bad_record.duns).to eq(@bad_duns)
        expect(@bad_record.error_messages).to match(/MASTER APP FAILED TO SAVE/)
        expect(@bad_record.error_messages).to match(/This is my error/)
      end

      it "should not have an app id" do
        expect(@bad_record.sba_application_id).to be_nil
      end
    end

    context "when no sub application (bdmis archive) was created" do
      before do
        @directory = 'spec/fixtures/bdmis_test/one_bad_apple'

        allow_any_instance_of(SbaApplication::EightAMaster).to receive(:sub_applications).and_return([])

        @return_value = Questionnaire::EightAMigrated.load_from_csv!(@directory)
        @bad_record = BdmisMigration.find_by(duns: @bad_duns)
      end

      it 'should not raise any errors' do
        expect(@return_value).to be_nil
      end

      it "should log an error in the BDMIS table" do
        expect(BdmisMigration.count).to be(1)
        expect(@bad_record.duns).to eq(@bad_duns)
        expect(@bad_record.error_messages).to match(/NO SUB APP CREATED FOR MASTER APP/)
      end

      it "should include the master app id in the error messages" do
        expect(@bad_record.error_messages).to match(/ID: \d+/)
      end

      it "should not have an app id" do
        expect(@bad_record.sba_application_id).to be_nil
      end
    end

    context "when answering the sub application fails" do
      before do
        @directory = 'spec/fixtures/bdmis_test/one_bad_apple'

        allow(Answer).to receive(:create!).and_raise "Some random error"

        @return_value = Questionnaire::EightAMigrated.load_from_csv!(@directory)
        @bad_record = BdmisMigration.find_by(duns: @bad_duns)
      end

      it 'should not raise any errors' do
        expect(@return_value).to be_nil
      end

      it "should log an error in the BDMIS table" do
        expect(BdmisMigration.count).to be(1)
        expect(@bad_record.duns).to eq(@bad_duns)

        expect(@bad_record.error_messages).to match(/ANSWER FAILED TO SAVE/)
        expect(@bad_record.error_messages).to match(/Some random error/)
      end

      it "should include the master app id in the error messages" do
        expect(@bad_record.error_messages).to match(/ID: \d+/)
      end

      it "should not have an app id" do
        expect(@bad_record.sba_application_id).to be_nil
      end
    end

    context "when submitting the sub application fails" do
      before do
        @directory = 'spec/fixtures/bdmis_test/one_bad_apple'

        allow_any_instance_of(SbaApplication::SubApplication).to receive(:submit!).and_raise "I will not submit"

        @return_value = Questionnaire::EightAMigrated.load_from_csv!(@directory)
        @bad_record = BdmisMigration.find_by(duns: @bad_duns)
      end

      it 'should not raise any errors' do
        expect(@return_value).to be_nil
      end

      it "should log an error in the BDMIS table" do
        expect(BdmisMigration.count).to be(1)
        expect(@bad_record.duns).to eq(@bad_duns)

        expect(@bad_record.error_messages).to match(/SUB APP FAILED TO SUBMIT/)
        expect(@bad_record.error_messages).to match(/I will not submit/)
      end

      it "should include the master app id in the error messages" do
        expect(@bad_record.error_messages).to match(/ID: \d+/)
      end

      it "should not have an app id" do
        expect(@bad_record.sba_application_id).to be_nil
      end
    end

    context "when submitting the master application fails" do
      before do
        @directory = 'spec/fixtures/bdmis_test/one_bad_apple'

        allow_any_instance_of(SbaApplication::EightAMaster).to receive(:submit!).and_raise "Seriously, I will not submit"

        @return_value = Questionnaire::EightAMigrated.load_from_csv!(@directory)
        @bad_record = BdmisMigration.find_by(duns: @bad_duns)
      end

      it 'should not raise any errors' do
        expect(@return_value).to be_nil
      end

      it "should log an error in the BDMIS table" do
        expect(BdmisMigration.count).to be(1)
        expect(@bad_record.duns).to eq(@bad_duns)

        expect(@bad_record.error_messages).to match(/FAILED TO SUBMIT MASTER APP/)
        expect(@bad_record.error_messages).to match(/Seriously, I will not submit/)
      end

      it "should include the master app id in the error messages" do
        expect(@bad_record.error_messages).to match(/ID: \d+/)
      end

      it "should not have an app id" do
        expect(@bad_record.sba_application_id).to be_nil
      end
    end

    pending "when failing to activate the certificate" do
      before do
        @directory = 'spec/fixtures/bdmis_test/one_bad_apple'

        allow_any_instance_of(Certificate).to receive(:activate_for_bdmis!).and_raise "Nonactive"

        @return_value = Questionnaire::EightAMigrated.load_from_csv!(@directory)
        @bad_record = BdmisMigration.find_by(duns: @bad_duns)
      end

      it 'should not raise any errors' do
        expect(@return_value).to be_nil
      end

      it "should log an error in the BDMIS table" do
        expect(BdmisMigration.count).to be(1)
        expect(@bad_record.duns).to eq(@bad_duns)

        expect(@bad_record.error_messages).to match(/FAILED TO ACTIVATE NEW CERT/)
        expect(@bad_record.error_messages).to match(/Nonactive/)
      end

      it "should include the master app id in the error messages" do
        expect(@bad_record.error_messages).to match(/ID: \d+/)
      end

      it "should not have an app id" do
        expect(@bad_record.sba_application_id).to be_nil
      end
    end
  end
end

