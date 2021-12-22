module ApplicationDashboard
  class BdmisHistoryController < BaseController
    include ActivityLog
    before_action :ensure_sba_user

    def index
      s3 = S3Service.new
      org_prefix = @sba_application.organization.bdmis_migrated_data_s3_folder_name
      bucket_name = ENV['BDMIS_DATA_S3_BUCKET']
      @action_history_files = s3.list_files_in_folder(bucket_name, "bdmis_final/action_history/", org_prefix)
      @notes = s3.list_files_in_folder(bucket_name, "bdmis_final/notes/", org_prefix)
      @recommendations = s3.list_files_in_folder(bucket_name, "bdmis_final/recommendation/", org_prefix)
      @rma = s3.list_files_in_folder(bucket_name, "bdmis_final/rma/", org_prefix)
    end

    def view_file
      bucket_name = ENV['BDMIS_DATA_S3_BUCKET']
      s3 = S3Service.new
      file = s3.get_file_object(bucket_name, params[:file_name])
      @data = file.get.body.read
      render :text => @data
    end
  end
end
