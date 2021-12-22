require 'rails_helper'

RSpec.describe SbaAnalyst::DeterminationsController, type: :controller do
  describe "# Access " do
    before(:each) do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["HTTP_REFERER"] = "/"
      @user = vendor_user

      # Setting up review
      @certificate_type = load_sample_questionnaire('wosb')
      @app = @certificate_type.questionnaire('initial').start_application(@user.one_and_only_org)
      @app.ignore_creator = true
      @app.workflow_state = "under_review"
      @app.save!

      @review = create(:review_for_determination)
      @review.sba_application = @app
      @review.save!

      # Setting up users
      @analyst = create(:analyst_user)
      @supervisor = create(:sba_supervisor_user)
    end

    it 'raise when a non authorized user attempts to make a determination' do
      sign_in @analyst
      params = { review: {workflow_state: "determination_made"}, review_id: @review.case_number, original_reviewer_id: @analyst, reviewer_id: @analyst, determination: { decision: 0, decider_id: @analyst.id }, assessment: { note_body: "" } }
      post 'create', params
      expect(response).to redirect_to(root_path)
      sign_out @analyst
    end

    it 'should make a determination when an authorized user attempts to make a determination' do
      sign_in @supervisor
      params = { review: {workflow_state: "determination_made"}, review_id: @review.case_number, original_reviewer_id: @analyst, reviewer_id: @analyst, determination: { decision: 0, decider_id: @analyst.id }, assessment: { note_body: "" } }
      cert = Certificate.first
      expect(cert.workflow_state).to eq("active")
      post 'create', params
      expect(cert.reload.workflow_state).to eq("ineligible")
      expect(response).to redirect_to(root_path)
      sign_out @supervisor
    end
  end
end 
