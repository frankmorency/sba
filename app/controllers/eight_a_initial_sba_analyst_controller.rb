class EightAInitialSbaAnalystController < ApplicationController
  before_action :authenticate_user!
  before_action :require_eight_a_initial_sba_analyst

  protected

  def require_eight_a_initial_sba_analyst
    user_not_authorized unless (current_user.can_any? :ensure_8a_initial_sba_analyst)
  end
end