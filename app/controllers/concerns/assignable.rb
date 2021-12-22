module Assignable
  extend ActiveSupport::Concern

  def determine_roles sba_application
    sba_application.is_initial? ? ['sba_analyst_8a_cods', 'sba_supervisor_8a_cods'] : ['sba_analyst_8a_cods']
  end

  def get_assignment_users roles
    @phily_users = User.filter_by_duty_stations_and_roles(['Philadelphia'], roles)
    @sf_users = User.filter_by_duty_stations_and_roles(['San Francisco'], roles)
    @hq_users = User.with_role(:sba_supervisor_8a_hq_program)
  end
end
