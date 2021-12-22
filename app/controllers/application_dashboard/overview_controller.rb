module ApplicationDashboard
  class OverviewController < BaseController
    include ActivityLog
    before_action :ensure_sba_user, except: [:index, :section_info]
    before_action :set_activities, only: [:index]

    def index
      if (can? :ensure_contributor, current_user)
        render template: 'contributors/application_dashboard/overview/index'
      elsif (can? :ensure_vendor, current_user)
        render template: 'vendor_admin/application_dashboard/overview/index'
      elsif (can? :sba_user, current_user)
        render :index
      else
        return user_not_authorized
      end
    end

    def edit_duty_station
    end

    def section_info
      @section = Section.find(params[:id])
      respond_to do |format|
        format.js { render layout: false }
        format.xml { render xml: @section }
      end
    end

    def assign_duty_station
      duty_station = DutyStation.find_by(id: field_office_params)

      if duty_station
        @sba_application.assign_duty_station_to_app(duty_station)
        flash[:success] = 'The district office has been updated.'
      else
        flash[:error] = 'There was a problem with setting the district office.'
      end

      redirect_to sba_application_application_dashboard_overview_index_path(@sba_application)
    end

    def edit_servicing_bos
      @duty_stations = DutyStation.stations_with_district_office_sba_users
    end

    def assign_servicing_bos
      if bos_params == 'None'
        @sba_application.clear_servicing_bos
        flash[:success] = 'The servicing BOS has been updated.'
      else
        servicing_bos = User.find_by(id: bos_params)
        if servicing_bos
          @sba_application.assign_servicing_bos_to_certificate(servicing_bos)
          flash[:success] = 'The servicing BOS has been updated.'
        else
          flash[:error] = 'There was a problem with setting the servicing BOS.'
        end
      end

      redirect_to sba_application_application_dashboard_overview_index_path(@sba_application)
    end

    private
      def field_office_params
        params.require(:field_office)
      end

      def bos_params
        params.require(:user_id)
      end
  end
end
