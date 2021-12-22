module ApplicationDashboard
  class ActivityLogController < BaseController
    include ActivityLog
    before_action :ensure_sba_user
    before_action :set_activities, only: [:index]

    def index
    end

    # export current activities to csv
    def export
      if @sba_application.blank?
        response = { message: 'not in an application' }
        render json: response, status: :forbidden
      else
        @activities = CertifyActivityLog::Activity.export(application_id: @sba_application.id)
        csv_data = @activities[:body]
        export_filename = "activity_log_application_id_#{@sba_application.id}_export_#{Time.now.utc.strftime('%Y-%m-%d_%H-%M_%Z')}.csv"
        send_data csv_data, filename: export_filename, disposition: 'attachment'
      end
    end
  end
end