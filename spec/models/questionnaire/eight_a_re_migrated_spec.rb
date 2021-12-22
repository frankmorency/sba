require "rails_helper"

STATUS_TO_DUNS = {
  "approved" => "582976669",
  "withdrawn" => "588197983",
  "early_graduated" => "595621168",
  "graduated" => "588539248",
  "terminated" => "593793246",
  "suspended" => "595237256",
  "new" => "599666000",
}

RSpec.describe Questionnaire::EightAMigrated, type: :model do
  describe "load_from_csv!" do
    before do
      allow(Signature).to receive(:new).and_return double(terms: [double(process: "term 1")])

      allow(MvwSamOrganization).to receive(:get).with(any_args) do |duns|
        MvwSamOrganization.new(duns: duns, tax_identifier_type: "EIN", tax_identifier_number: duns)
      end

      @directory = "spec/fixtures/bdmis_test/pre_reimport_statuses"

      #Setup Duty Station needed by the migration
      [["San Francisco", 1],
       ["Philadelphia", 1]].each do |couple|
        DutyStation.create!(name: couple[0], region_code: couple[1])
      end
    end

    context "a file (in the old format) with seven cases" do
      before do
        @return_value = Questionnaire::EightAMigrated.load_from_csv!(@directory)
      end

      it "should not raise any errors" do
        expect(@return_value).to be_nil
      end

      it "should update the bdmis_migrations table with the application ids" do
        expect(BdmisMigration.count).to be(7)
        expect(BdmisMigration.pluck(:error_messages).join).to eq("")
        expect(BdmisMigration.where(error_messages: nil).count).to be(7)
        expect(BdmisMigration.where(sba_application_id: nil).count).to be(0)
      end

      it 'should create seven "submitted" applications' do
        SbaApplication.find(BdmisMigration.pluck(:sba_application_id)).each do |app|
          expect(app.workflow_state).to eq("submitted")
        end
      end

      it 'should create seven "active" certificates' do
        SbaApplication.find(BdmisMigration.pluck(:sba_application_id)).each do |app|
          expect(app.certificate.workflow_state).to eq("active")
        end
      end

      context "then reimporting with the file containing last_recommendation and current_assigned_email" do
        before do
          @return_value = Questionnaire::EightAMigrated.load_from_csv!("spec/fixtures/bdmis_test/reimport_statuses")
        end

        describe "the approved case" do
          before do
            @app = SbaApplication.find(BdmisMigration.find_by(duns: STATUS_TO_DUNS["approved"]).sba_application_id)
          end

          # Story said complete, but looking at existing data of active
          it 'should now be "submitted"' do
            expect(@app.workflow_state).to eq("submitted")
          end

          it 'should still still have an "active" cert' do
            expect(@app.certificate.workflow_state).to eq("active")
          end

          it "should not have the suspended flag set" do
            expect(@app.certificate).not_to be_suspended
          end
        end

        describe "the withdrawn case" do
          before do
            @app = SbaApplication.find(BdmisMigration.find_by(duns: STATUS_TO_DUNS["withdrawn"]).sba_application_id)
          end

          it 'should be "complete"' do
            expect(@app.workflow_state).to eq("complete")
          end

          it 'should cert should be "withdrawn"' do
            expect(@app.certificate.workflow_state).to eq("withdrawn")
          end

          it "should not have the suspended flag set" do
            expect(@app.certificate).not_to be_suspended
          end
        end

        describe "the early_graduated case" do
          before do
            @app = SbaApplication.find(BdmisMigration.find_by(duns: STATUS_TO_DUNS["early_graduated"]).sba_application_id)
          end

          it 'should be "complete"' do
            expect(@app.workflow_state).to eq("complete")
          end

          it 'should cert should be "early_graduated"' do
            expect(@app.certificate.workflow_state).to eq("early_graduated")
          end

          it "should not have the suspended flag set" do
            expect(@app.certificate).not_to be_suspended
          end
        end

        describe "the graduated case" do
          before do
            @app = SbaApplication.find(BdmisMigration.find_by(duns: STATUS_TO_DUNS["graduated"]).sba_application_id)
          end

          it 'should be "complete"' do
            expect(@app.workflow_state).to eq("complete")
          end

          it 'should cert should be "graduated"' do
            expect(@app.certificate.workflow_state).to eq("graduated")
          end

          it "should not have the suspended flag set" do
            expect(@app.certificate).not_to be_suspended
          end
        end

        describe "the terminated case" do
          before do
            @app = SbaApplication.find(BdmisMigration.find_by(duns: STATUS_TO_DUNS["terminated"]).sba_application_id)
          end

          it 'should be "complete"' do
            expect(@app.workflow_state).to eq("complete")
          end

          it 'should cert should be "terminated"' do
            expect(@app.certificate.workflow_state).to eq("terminated")
          end

          it "should not have the suspended flag set" do
            expect(@app.certificate).not_to be_suspended
          end
        end

        # describe "the suspended case" do
        #   before do
        #     @app = SbaApplication.find(BdmisMigration.find_by(duns: STATUS_TO_DUNS['suspended']).sba_application_id)
        #   end

        #   it 'should still be "submitted"' do
        #     expect(@app.workflow_state).to eq('submitted')
        #   end

        #   it 'should still still have an "active" cert' do
        #     expect(@app.certificate.workflow_state).to eq('active')
        #   end

        #   it 'should have the suspended flag set' do
        #     expect(@app.certificate).to be_suspended
        #   end
        # end

        describe "the rejected case" do
          it "should not be created (dealing with this later)" do
            expect(BdmisMigration.find_by(duns: STATUS_TO_DUNS["rejected"])).to be_nil
            expect(SbaApplication.find_by(workflow_state: "rejected")).to be_nil
          end
        end

        describe "the new (graduated) case" do
          before do
            @app = SbaApplication.find(BdmisMigration.find_by(duns: STATUS_TO_DUNS["new"]).sba_application_id)
          end

          it 'should be "complete"' do
            expect(@app.workflow_state).to eq("complete")
          end

          it 'should still still have an "graduated" cert' do
            expect(@app.certificate.workflow_state).to eq("graduated")
          end

          it "should not have the suspended flag set" do
            expect(@app.certificate).not_to be_suspended
          end
        end
      end
    end
  end
end
