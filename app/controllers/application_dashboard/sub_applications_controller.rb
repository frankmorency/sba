module ApplicationDashboard
  class SubApplicationsController < BaseController
    include ActivityLog
    before_action :ensure_sba_user
    before_action :set_activities, only: [:show]

    def show
      @sub_application = @sba_application.sub_applications.find(params[:id])
      @section = @sba_application.sub_application_sections.find_by(sub_application_id: params[:id])

      if @section.is_dvd_contributor? || @section.is_dvd_spouse? || @section.is_dvd_partner?
        contributor = @sub_application.creator
      elsif @section.is_dvd_vendor?
        contributor = @sba_application.organization.vendor_admin_user
      end

      @financials = FinancialSummary.new(contributor, @sub_application)
    end
  end
end