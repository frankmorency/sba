require 'rails_helper'

RSpec.describe UserPresenter, type: :presenter do
  describe "#name_with_assigned_cases_count" do
    before do
      @user = create(:user_random)
      @user_presenter = UserPresenter.new(@user, self)
    end

    it 'should return user name with no assigned cases' do
      expect(@user_presenter.name_with_assigned_cases_count).to eq("#{@user.name} (0 cases)")
    end
  end
end
