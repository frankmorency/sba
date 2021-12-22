require 'rails_helper'

RSpec.describe SbaApplicationsController, type: :model do

  before do
    @sa_controller = SbaApplicationsController.new
    @sa_controller.params = {id: 1}
    @org = build(:organization)
    @app_proxy = double("SbaApplicationsProxy")
  end

  describe "#set_application" do
    it 'should scope it to the organizations apps' do
      allow(@sa_controller).to receive(:current_organization).and_return @org
      expect(@app_proxy).to receive(:find).with(1)
      expect(@org).to receive(:sba_applications).and_return(@app_proxy)

      @sa_controller.send :set_application
    end
  end

  describe "#setup_master_app" do
    before do
      @certificate_type = load_sample_questionnaire('wosb')
      @user = create(:org_with_user).default_user
      @app = Spec::Fixtures::SampleApplication.load(@user, @certificate_type, :draft)
      @org = @user.one_and_only_org

      @sa_controller.instance_variable_set(:@organization, @org)
      @sa_controller.params = {master_application_id: @app.id, section_id: @app.first_section.name}
      @app_proxy = double("App Proxy")
      @section_proxy = double("Section Proxy")
    end

    it 'should properly scopes things to the org' do
      expect(@org).to receive(:sba_applications).and_return @app_proxy
      expect(@app_proxy).to receive(:find).with(@app.id).and_return @app
      expect(@app).to receive(:every_section).and_return @section_proxy
      expect(@section_proxy).to receive(:find_by).with({name: @app.first_section.name})

      @sa_controller.send :setup_master_app, {}
    end
  end
end