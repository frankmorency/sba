require 'rails_helper'

RSpec.describe "Application Versioning", type: :model do
  describe SbaApplication do
    before do
      cert = double(Certificate)
      @user = create(:user_with_org)
      @app = build(:basic_application, organization: @user.one_and_only_org)
      allow(@app).to receive(:certificate).and_return cert
      allow(cert).to receive(:deactivate!).and_return true
      allow(cert).to receive(:on_return_to_vendor)
      allow(cert).to receive(:id).and_return 6
      @app.save!
      @app.reload
    end

    describe "saving the first version" do
      it 'should set the version to 1 and the current application to itself' do
        expect(@app.version_number).to eq(1)
        expect(@app.current_sba_application_id).to eq(@app.id)
        expect(@app).to be_is_current
      end
    end

    context "resubmitting the application" do
      before do
        @app.skip_copy_sections_and_rules = true
        @version = @app.return_for_modification
        @app.reload
        @version.reload
      end

      describe "the new version" do
        it 'should properly setup the new version' do
          expect(@version.version_number).to eq(2)
          expect(@version.current_sba_application_id).to eq(@version.id)
          expect(@version).to be_is_current
        end
      end

      describe "the initial version" do
        it 'should no longer be the current version' do
          expect(@app.version_number).to eq(1)
          expect(@app.current_sba_application_id).to eq(@version.id)
          expect(@app.last_version_number).to eq(2)
          expect(@app).not_to be_is_current
        end
      end

      describe "all_versions" do
        it 'should include all versions' do
          expect(@app.revisions.count).to eq(2)
          expect(@app.revisions).to include(@app)
          expect(@app.revisions).to include(@version)
          expect(@version.revisions.count).to eq(2)
          expect(@version.revisions).to include(@app)
          expect(@version.revisions).to include(@version)
        end

        describe "current" do
          it 'should be the new version' do
            expect(@version.current).to eq(@version)
          end
        end
      end
    end

    # SHOULD YOU BE ABLE TO DELETE PREVIOUS VERSIONS?  JUST THE CURRENT VERSION
    context "deleting the latest verison (when there are two versions" do
      before do
        @app.skip_copy_sections_and_rules = true
        @version = @app.return_for_modification
        @version.destroy
        @app.reload
      end

      pending "the last version, current and counts" do
        it 'should what exactly?' do
          # expect(@app.last_version_number).to eq(1)
          # expect(@app.all_versions.count).to eq(1)
          # expect(@app.current).to eq(@app)
          # expect(@app.is_current?).to be_truthy
        end
      end
    end

  end
end
