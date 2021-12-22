class PermissionRequestsController < ApplicationController
    
    def index
        @permission_requests = PermissionRequest
                                    .requested
                                    .order(created_at: :desc)
                                    .paginate(page: params[:page])

        respond_to do |format|
          format.html
          format.csv { send_data AccessRequest.all.order(id: :desc).to_csv, filename: "permission-request-#{Date.today}.csv" }
        end
    end
    
    def show
        @permission_request = PermissionRequest
                                .where(access_request_id: params[:id])
                                .order(created_at: :asc)
    end
end
