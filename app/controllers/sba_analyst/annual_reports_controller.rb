module SbaAnalyst
  class AnnualReportsController < SbaAnalystController
    before_action :set_annual_report, except: [:index]
    before_action :ensure_mpp_analyst, except: [:index, :show]

    def index
      @annual_reports = AnnualReport.all
    end

    def show
      @organization = @annual_report.certificate.organization
      @sba_application = @annual_report.sba_application
      prepare_app_for_viewing false
    end

    def approve
      if @annual_report.approve!(current_user)
        flash[:notice] = "This annual report has been approved"
      else
        flash[:error] = "There was an error approving the annual report"
      end

      redirect_to sba_analyst_annual_reports_path
    end

    def decline
      if @annual_report.decline!(current_user)
        flash[:notice] = "This annual report has been declined"
      else
        flash[:error] = "There was an error declining the annual report"
      end

      redirect_to sba_analyst_annual_reports_path
    end

    def return_to_vendor
      if @annual_report.return_to_vendor!(current_user)
        flash[:notice] = "This annual report has been returned"
      else
        flash[:error] = "There was an error returning the annual report"
      end

      redirect_to sba_analyst_annual_reports_path
    end

    private

    def set_annual_report
      @annual_report = AnnualReport.find(params[:id])
    end
  end
end