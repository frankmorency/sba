class VendorAdmin::AppsController < ApplicationController

  def index
    @applications = current_user.organizations.first.sba_applications.where(type: "SbaApplication::EightAMaster")
  end

end