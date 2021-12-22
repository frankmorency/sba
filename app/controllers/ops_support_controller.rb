class OpsSupportController < ApplicationController
  before_action :authenticate_user!
  before_action :require_ops_support

  private

  def require_ops_support
    user_not_authorized unless current_user.can? :ensure_ops_support
  end
end
