require 'rails_helper'

RSpec.describe ApplicationController, type: :model do

  before do
    @app_controller = ApplicationController.new
    @app_controller.params = {sba_application_id: 1}
    @org = build(:organization)
    @app_proxy = double("SbaApplicationsProxy")
    expect(@app_controller).to receive(:current_organization).at_least(:once).and_return @org
  end

  describe "#set_application" do
    it 'should scope it to the organizations apps' do
      expect(@app_proxy).to receive(:find).with(1)
      expect(@org).to receive(:sba_applications).and_return(@app_proxy)

      @app_controller.send :set_application
    end
  end
end
