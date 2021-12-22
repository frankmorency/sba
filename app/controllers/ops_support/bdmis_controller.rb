module OpsSupport
  class BdmisController < OpsSupportController
    skip_load_and_authorize_resource
    before_action :require_ops_support

    def index
      duns = params[:duns]
      @migrations = BdmisMigration.where(duns: duns).order("created_at desc")
      @can_retry = @migrations.where.not(sba_application_id: nil).count == 0 # Allow retry only if the firm hasn't been successfully imported before
    end

    def show
      @migrations = BdmisMigration.find(duns_params)
    end

    def re_import
      migration = BdmisMigration.find(id_params)

      message = Questionnaire::EightAMigrated.retry_import!(migration.attributes.symbolize_keys)
      if message.nil?
        flash[:success] = 'BDMIS Migration sucessfully re-imported'
      else
        flash[:error] = message
      end
      redirect_to ops_support_bdmis_path
    end

    protected
    def duns_params
      params.require(:duns)
    end

    def id_params
      params.require(:id)
    end

  end
end
