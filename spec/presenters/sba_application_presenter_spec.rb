require 'rails_helper'

RSpec.describe SbaApplicationPresenter, type: :presenter do
  describe "#masthead_subtitle" do
    context "when questionnaire is eight_a_annual_review" do
      before do
        @app_presenter = SbaApplication.new questionnaire: Questionnaire.new(name: 'eight_a_annual_review'), review_number: 3
      end

      it 'should return the program year verbiage' do
        expect(@app_presenter.masthead_subtitle).to eq("For Program Year 3")
      end
    end

    context "when questionnaire is NOT eight_a_annual_review " do
      before do
        @app_presenter = SbaApplication.new questionnaire: Questionnaire.new(name: 'eight_a_initial'), review_number: 3
      end

      it 'should be falsey (nil)' do
        expect(@app_presenter.masthead_subtitle).to be_falsey
      end
    end
  end
end
