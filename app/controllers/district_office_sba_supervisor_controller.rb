class DistrictOfficeSbaSupervisorController < ApplicationController
  before_action :authenticate_user!
  before_action :require_eight_a_migrated_sba_supervisor

  protected

  def require_eight_a_migrated_sba_supervisor
    user_not_authorized unless (current_user.can_any? :assign_8a_role_district_office_supervisor)
  end
end