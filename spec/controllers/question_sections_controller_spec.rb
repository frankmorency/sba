require 'rails_helper'

RSpec.describe Section::QuestionSectionsController, type: :controller do
  include Devise::TestHelpers

  def parameters(questionnaire, app, section, questions)
    params = {
        answers: {},
        commit: "Continue",
        sba_application_id: "#{app}",
        questionnaire_id: "#{questionnaire}",
        id: "#{section}"
    }

    questions.each do |id, value|
      params[:answers]["#{id}"] = {
          question_text: "this is the question",
          question_name: "q_name",
          answered_for_type: "",
          answered_for_id: "",
          value: value,
          attachment: "no_attachments_needed"
      }
    end

    params.with_indifferent_access
  end

  describe "PUT update" do
    context "Given a questionnaire and application" do
      before do
        allow_any_instance_of(Organization).to receive(:is_active?).and_return(true)
        @certificate_type = load_sample_questionnaire('wosb')
        @other_user = create(:org_with_user).default_user
        @other_app = Spec::Fixtures::SampleApplication.load(@other_user, @certificate_type, :draft)


        @user = create(:org_with_user).default_user
        @app = Spec::Fixtures::SampleApplication.load(@user, @certificate_type, :draft)

        @params = parameters(@certificate_type.name, @app.id, @app.first_section.name, {
            "#{Question.get('8aq1').id}": 'no'
        })

        sign_in @user
      end

      context "Given valid question ids that are valid for the applicaiton" do
        it "should work" do
          put :update, @params

          expect(response).to redirect_to("/sba_applications/#{@app.id}/questionnaires/#{@certificate_type.name}/question_sections/third_party_cert_part_1/edit")
          expect(flash[:error]).to be_nil
        end

        it 'should ignore the question name and text' do
          expect(Answer).to_not respond_to(:'question_text=')
          expect(Answer).to_not respond_to(:'question_name=')
        end
      end

      context "Given a user trying hack the answered_for information" do
        before do
          @other_biz_partner = create(:business_partner, sba_application: @other_app)

          @params[:answers]["#{Question.get('8aq1').id}"][:answered_for_type] = 'BusinessPartner'
          @params[:answers]["#{Question.get('8aq1').id}"][:answered_for_id] = @other_biz_partner.id
        end

        it "should raise an error" do
          expect {
            put :update, @params
          }.to raise_error(Error::DataManipulation)

        end
      end
    end
  end
end
