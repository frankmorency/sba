require 'rails_helper'

RSpec.describe SbaAnalyst::DashboardController, type: :controller do
    describe "GET /sba_analyst/dashboard/organization?enc" do
        before(:each) do
            request.env["devise.mapping"] = Devise.mappings[:user]
            @user = create(:analyst_user)
            sign_in @user
        end
        
        context "SAM.GOV data available in sam_organizations" do
            it "should have content SAM.gov profile" do
                duns_number = $encryptor.encrypt('994398723')
                get :show, enc: duns_number
                expect(response).to have_http_status(:success) # 200
            end
        end
        
        context "SAM.GOV data in sam_organizations with sam_extract_code D" do
            it "should have content SAM.gov profile" do
                duns_number = $encryptor.encrypt('986643337')
                get :show, enc: duns_number
                expect(response).to have_http_status(:success) # 200
            end
        end

        context "SAM.GOV data not in sam_organizations" do
            it "should have content SAM.gov profile" do
                duns_number = $encryptor.encrypt('999999999')
                get :show, enc: duns_number
                expect(response).to have_http_status(:success) # 200
            end
        end
    end
end