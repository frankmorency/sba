module SbaAnalyst
  class DashboardController < SbaAnalystController
    skip_load_and_authorize_resource

    include SupervisorAccessRequestsHelper

    before_action :require_sba_analyst, only: [:index, :show]
    before_action :require_search
    before_action :require_ops_support, only: [:create_8a_annual_review]

    def index
      super
      @sam_organizations = MvwSamOrganization.sba_analyst_search(params[:query].strip).try(:page, params[:page]).try(:per_page, 5) unless params[:query].nil?
    end

    def show
      @organization = set_organization

      unless @organization.nil?
        @applications = @organization.sba_applications.for_display.reject {|app| app.certificate&.workflow_state == 'ineligible' }
        @eight_a_apps = @applications.select  {|app| app.type == "SbaApplication::EightAAnnualReview" }
        @certificates = @organization.displayable_certificates
        @eight_a_certs = @certificates.select  {|cert| cert.type == "Certificate::EightA" }
        @eight_a_init_draft_apps = @applications.select {|app| app.type == "SbaApplication::EightAMaster" && app.certificate_id == nil }
        @wosb_certs = @organization.displayable_certificates.joins(:certificate_type).where('certificate_types.name =? OR certificate_types.name = ?', 'wosb', 'edwosb')
        # @wosb_certs = @certificates.select  {|cert| cert.type.include?('Edwosb') || cert.type.include?('Wosb') }]
        @wosb_draft_apps = @applications.select {|app| ['wosb','edwosb'].include?(app&.program&.name) && app.certificate_id == nil }
        @wosb_apps = @organization.sba_applications.for_display.joins(questionnaire: :program).where('programs.name = ?', 'wosb')
        @mpp_certs = @certificates.select  {|cert| cert.type.include?('Mpp') }
        @mpp_draft_apps = @applications.select {|app| ['mpp'].include?(app&.program&.name) && app.certificate_id == nil }
        @annual_reports = AnnualReport.where("sba_application_id IN (?)", @organization.sba_applications.collect(&:id))
        @adverse_actions = @organization.adverse_action_reviews
        @info_requests = @applications.select {|app| app.type == "SbaApplication::EightAInfoRequest"}
        # Give the bis's vendor admin
        @user = @organization.users.where("roles_map#>>'{Legacy}' LIKE '%admin%'").first
        @documents = @organization.documents.order(:updated_at).reverse_order
        @email_notification_histories = @organization.email_notification_histories.order(created_at: 'asc')
        @sam_org =  MvwSamOrganization.find_by_duns(@organization.duns_number)
      end
    end

    def return_for_modification
      @sba_application = SbaApplication.find(sba_application_id)

      @sba_application.return_for_modification
      flash[:notice] = "A new application has been reopened for the vendor"
      redirect_to sba_analyst_organization_org_dashboard_show_path(@sba_application.organization)
    end

    def download_zip
      @sba_application = SbaApplication.find(sba_application_id)
      @folder_name = @sba_application.organization.folder_name
      @file_name = "#{sba_application_id}.zip"

      send_data S3Service.new.get_file_object(ENV['AWS_S3_BUCKET_NAME'], "#{@folder_name}/#{@file_name}").get.body.read,
                filename: @file_name,
                type: "application/zip"
    end

    def generate_zip
      @sba_application = SbaApplication.find(sba_application_id)

      unless Rails.env == 'development' && !ENV.has_key?('ZIP_LAMBDA_FUNCTION_NAME')
        @folder_name = "#{@sba_application.organization.folder_name}/"
        @file_name = "#{@sba_application.id}.zip"
        @original_file_names = @sba_application.documents.map(&:original_file_name)
        @stored_file_names = @sba_application.documents.map(&:stored_file_name)
        lambda = LambdaService.new
        lambda.invokeZipFunction ENV['AWS_S3_BUCKET_NAME'], @folder_name, @stored_file_names, @original_file_names, @file_name
      end

      @sba_application.zip_file_status = 1
      @sba_application.save!

      flash[:notice] = "A Zip file has been queued for creation with the application documents. It should be ready for download in 15 minutes."
      redirect_to sba_analyst_organization_org_dashboard_show_path(@sba_application.organization)
    end

    def create_8a_annual_review
      @sba_application = SbaApplication.find(sba_application_id)
      @organization = @sba_application.organization

      begin
        app = @organization.create_eight_a_annual_review!
        flash[:notice] = "Annual Review created succesfully!"
      rescue StandardError => e
        flash[:error] = "!ERROR! - #{e}"
      end

      redirect_to sba_analyst_organization_org_dashboard_show_path(@organization)
    end

    private

    def require_search
      user_not_authorized unless can? :view_search, current_user
    end

    # Overiding method form base class for ops support authorization
    def require_sba_analyst
      # providing better naming for method.
      require_sba_analyst_or_ops_support
    end

    def require_sba_analyst_or_ops_support
      user_not_authorized unless (current_user.can_any? :sba_user, :ensure_ops_support)
    end

    def require_ops_support
      user_not_authorized unless current_user.can?(:ensure_ops_support)
    end

    def set_organization
      if params[:organization_id]
        org = Organization.find_by_id(params[:organization_id])
      elsif params[:duns]
        org = Organization.from_duns(params[:duns])
      else
        parametres = $encryptor.decrypt_and_split_params(params[:enc])
        org = Organization.from_duns(parametres["duns_number"])
        unless org.present?
          org = Organization.find_by_duns_number(parametres["duns_number"])
        end
      end
      org
    end
  end
end
