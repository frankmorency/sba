module SbaWorkloadHelper

  def set_hide_info_path(application_id)
    case controller_path
      when 'district_office_sba_supervisor/dashboard'
        return hide_info_request_district_office_sba_supervisor_dashboard_index_path(application_id: application_id)
      when 'eight_a_initial_sba_analyst/dashboard'
        return hide_info_request_eight_a_initial_sba_analyst_dashboard_index_path(application_id: application_id)
      when 'eight_a_initial_sba_supervisor/dashboard'
        return hide_info_request_eight_a_initial_sba_supervisor_dashboard_index_path(application_id: application_id)
    end
    nil
  end
end