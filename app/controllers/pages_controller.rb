class PagesController < ApplicationController
  include HighVoltage::StaticPage

  before_action   :set_public_flag
  before_action   :run_me

  def run_me
    redirect_to after_sign_in_path_for(current_user) if params["id"] == "home" && current_user
  end
end
