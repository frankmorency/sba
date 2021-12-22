require 'rails_helper'

RSpec.describe OpsSupport::SamValidationController, type: :controller do
  describe "# Access " do
    before(:each) do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["HTTP_REFERER"] = "/"
      
      # Set up organization

      # Set up ops support user
      @ops_support_admin = create(:ops_support_admin_user)
      @ops_support_staff = create(:ops_support_staff_user)
    end

    # Try to test every method in the controller. Here is how you can run just the sam_validation_controller_spec test:
    # rspec spec/controllers/ops_support/sam_validation_controller_spec.rb

    describe "#index" do
      it 'displays the validate form to ops support Admin' do
        sign_in @ops_support_admin
        # ...
      end
      it 'displays the validate form to ops support Staff' do
        sign_in @ops_support_staff
        # ...
      end
    end

    describe "#show" do
      
    end

    describe "#validate" do
      it 'displays the validate form to ops support Admin' do
        sign_in @ops_support_admin
        # params = { duns: '11111111', tin: '123456789', mpin: 'AP98645' }
        # post 'validate', params
        # expect(response.body).to include('Exact match')
        # sign_out @analyst
      end
      it 'displays the validate form to ops support Staff' do
        sign_in @ops_support_staff
        # ...
      end
    end

    describe "#check_correctness" do
      
    end

    describe "#require_ops_support" do
      # SamValidationController.require_ops_support
    end
  end
end 
