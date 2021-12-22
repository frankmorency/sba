class ContractingOfficerController < ApplicationController
  before_action :authenticate_user!

  def require_co_access
    user_not_authorized unless can? :ensure_contracting_officer, current_user
  end
end
