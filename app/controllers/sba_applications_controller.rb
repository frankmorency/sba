class SbaApplicationsController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_user!
  before_action :set_current_organization, except: [:create, :show, :fill, :create_annual_review]
  before_action :handle_entity_owned, only: [:new, :create]
  before_action :set_application, except: [:new, :create, :show, :destroy]
  before_action :set_certificate_type, only: [:new, :create]
  before_action :ensure_organization_user, except: [:new, :create, :show, :fill, :create_annual_review]
  before_action :check_eight_a_feature

  def create_annual_review
    return head(:unauthorized) if Rails.env.production?

    @sba_application.certificate.update_attributes issue_date: 1.year.ago, workflow_state: 'active'
    app = @sba_application.certificate.organization.create_eight_a_annual_review!
    ApplicationController.helpers.log_activity_application_event('created_system', app.id)
  end

  def fill
    unless Rails.env.production?
      case @sba_application.questionnaire.name
        when 'eight_a_annual_review'
          Loader::EightAAnnual.load @sba_application.id
        when 'eight_a_initial'
          Loader::EightA.load @sba_application.id
        when 'eight_a_disadvantaged_individual', 'eight_a_disadvantaged_individual_annual_review'
          Loader::EightASubApp.load @sba_application.id
        when 'mpp', 'wosb', 'edwosb'
          Loader::Simple.load @sba_application.id
        else
          head :not_implemented
          return
      end

      if params[:submit] == 'true'
        @sba_application.submit!
        flash[:notice] = "Your app has been filled and submitted"
      else
        flash[:notice] = "Your app has been prepopulated - you can now go submit it"
      end

      redirect_to '/vendor_admin/dashboard'
    else
      head :unauthorized
    end
  end

  def new
    options = {questionnaire: @questionnaire}

    if params[:master_application_id]
      options[:master_application] = current_organization.sba_applications.find(params[:master_application_id])
      options[:type] = 'SbaApplication::SubApplication'
    else
      options[:kind] = params[:application_type_id] || SbaApplication::INITIAL
    end

    @sba_application = current_organization.sba_applications.new(options)
    @certificate_type = @sba_application.certificate_type unless @certificate_type

    ensure_renewable || return

    user_is_contributor = false
    user_is_contributor = true if can?(:contributor, current_user)

    unless @sba_application.valid_application?(user_is_contributor) && params[:num_of_results].to_i < 3
      wait_time = params[:num_of_results].to_i < 3 ? " 90 days" : " 1 year"

      flash[:info] = 'An application already exists in the system. You can submit a new application ' + wait_time + ' after the latest determination.'
      redirect_to vendor_admin_dashboard_index_path   # redirect user back to dashboard
    end

    #if @sba_application.is_a?(SbaApplication::SubApplication) && @sba_application.is_blocked_from_starting?
    #  flash[:info] = "You have selected to submit an appeal. You can't apply for reconsideration."
    #  redirect_to vendor_admin_dashboard_index_path
    #end

  end

  def show
    if can? :view_vendor_application, current_user
      @organization = Organization.find(params[:organization_id])
      @user = @organization.default_user
    else
      return unless set_current_organization
      @user = current_user
    end

    set_application

    @sections = @sba_application.get_answerable_section_list
    @answer_proxy = @sba_application.answers #.where({sba_application_id: @sba_application.id})

    load_business_partners

    render_read_only unless @sba_application.is_current?
  end

  def create
    @organization = current_user.one_and_only_org
    options = {kind: params[:kind] || params[:application_type_id]}
    options.merge! original_certificate_id: params[:original_certificate_id]

    if params.has_key?(:master_application_id)
      options = setup_master_app(options)
    end

    @sba_application  = @questionnaire.start_application(current_organization, options)
    @sba_application.original_certificate_id = params[:original_certificate_id]
    @sba_application.contributor_id = params[:contributor_id]
    @sba_application.creator = current_user

    @certificate_type = @sba_application.certificate_type

    ensure_renewable || return

    ensure_organization_user || return

    if @sba_application.save
      ApplicationController.helpers.log_activity_application_event('created', @sba_application.id, current_user.id)
      path = section_path_helper(@sba_application, @sba_application.first_section, true)
      redirect_to path
    else
      flash[:info] = "There was an error creating your application: #{@sba_application.errors.full_messages.join(', ')}"
      redirect_to vendor_admin_dashboard_index_path
    end
  end

  def update
    unless @sba_application.answered_every_section?
      flash[:error] = "Something went wrong. You didn't capture all required questions. Please reach out to the support team."
      redirect_to vendor_admin_dashboard_index_path
    else
      @sba_application.send(:remove_nonapplicable_answers_and_sections, current_user)

      @sba_application.current_user = current_user
      begin
        if @sba_application.is_a?(SbaApplication::SubApplication)
          update_sub_app
        else
          update_app

          redirect_to vendor_admin_dashboard_index_path
        end

      rescue Workflow::NoTransitionAllowed => e
        flash[:info] = e.message
        redirect_to vendor_admin_dashboard_index_path
      end
    end
  end

  def destroy
    @sba_application = current_organization.sba_applications.find(sba_application_id)
    # @sba_application.destroy will result in a timout due to too many dependancies, so we soft delete the application only
    if @sba_application.deleteable?
      # Soft delete contributors
      app_contributors = Contributor.where(sba_application_id: @sba_application.id)
      app_contributors.update_all(deleted_at: DateTime.now())
      # Soft delete sub-applications
      sub_apps = SbaApplication.where(master_application_id: @sba_application.id, type: 'SbaApplication::SubApplication')
      sub_apps.update_all(deleted_at: DateTime.now())
      # Soft delete application
      @sba_application.update_attribute(:deleted_at, DateTime.now())
    else
      flash[:error] = "This application cannot be deleted. Please contact support for further assistance."
    end
    redirect_to vendor_admin_dashboard_index_path
  end

  private

  def update_app
    auto_assign_duty_station
    @certificate = @sba_application.submit!

    if @sba_application.returned_reviewer && @sba_application.respond_to?(:start_review_process)
      @sba_application.start_review_process(@sba_application.returned_reviewer)
      @sba_application.send_application_resubmitted_notification(@sba_application)
      ApplicationController.helpers.log_activity_application_state_change('resubmitted', @sba_application.id, current_user.id)
    else
      @sba_application.send_application_submited_notification(@sba_application)
      ApplicationController.helpers.log_activity_application_state_change('submitted', @sba_application.id, current_user.id)
    end
    @certificate = @sba_application.annual_report.try(:certificate) if @certificate == true
    flash[:success] = 'Your application has been submitted'

    invoke_lambda_zip_function # create zip with all documents in application

    unless generate_certificate_pdf
      flash[:success] += ' but certificate pdf generation failed, check with support team'
    end
  end

  def update_sub_app
    if @sba_application.is_reconsideration? && @sba_application.reconsideration_or_appeal_deadline_passed?
      flash[:error] = SbaApplication::SubApplication::UNABLE_TO_SUBMIT_RECONSIDERATION_OR_APPEAL_MESSAGE
      redirect_to vendor_admin_dashboard_index_path
      return
    end

    @sba_application.submit!
    flash[:success] = "#{@sba_application.questionnaire.title} section is complete"

    if @sba_application.is_adhoc? || @sba_application.is_reconsideration?
      redirect_to "/sba_application/#{@sba_application.master_application.id}/application_dashboard/overview"
    else
      redirect_to section_path_helper @sba_application.master_application, @sba_application.master_application.first_section, true
    end
  end

  def setup_master_app(options)
    @master_application, @master_section = @organization.build_master_app(master_app_id, master_section_id)

    options.merge!(master_application: @master_application, master_section: @master_section)
  end

  def generate_certificate_pdf
    return if Rails.env.test? || Rails.env.development? # AC: added this to bypass error on development

    file_name = "#{@certificate.certificate_type.name}_certificate_#{@certificate.id}"
    html = render_to_string('certificate/pdf_template', :layout => "pdf.slim")
    kit = PDFKit.new(html)
    Document.upload_document("#{@certificate.organization.folder_name}/generated_docs", kit.to_pdf, file_name)
  end

  def invoke_lambda_zip_function
    unless (Rails.env == 'development' && !ENV.has_key?('ZIP_LAMBDA_FUNCTION_NAME')) || Rails.env.test?
      @folder_name = "#{@sba_application.organization.folder_name}/"
      @file_name = "#{@sba_application.id}.zip"

      docs_hash = {}

      @sba_application.answers.each do |ans|
        ans.documents.each do |doc|
          docs_hash[doc.id] = doc unless docs_hash.has_key?(doc.id)
        end
      end

      docs = docs_hash.values

      if docs.count > 0
        @original_file_names = docs_hash.values.map(&:original_file_name)
        @stored_file_names = docs_hash.values.map(&:stored_file_name)
        lambda = LambdaService.new
        lambda.invokeZipFunction ENV['AWS_S3_BUCKET_NAME'], @folder_name, @stored_file_names, @original_file_names, @file_name
        @sba_application.zip_file_status = 1
        @sba_application.save!
      end
    end
  end

  def handle_entity_owned
    if current_organization.entity_owned?
      params[:application_type_id] = SbaApplication::ENTITY_OWNED_INITIAL
    end
  end

  def set_certificate_type
    if ! params[:certificate_type_id].blank? && params[:master_application_id].blank?
      @certificate_type = CertificateType.find_by(name: certificate_params) || CertificateType.find(certificate_params)
      @questionnaire = @certificate_type.questionnaire(params[:application_type_id] || SbaApplication::INITIAL)
    elsif ! params[:questionnaire_id].blank?
      @questionnaire = Questionnaire.find_by(name: questionnaire_params)
      
      unless @questionnaire.certificate_type.nil?
        @certificate_type = @questionnaire.certificate_type
      end
    end
  end

  def ensure_renewable
    return true unless params[:kind] == SbaApplication::ANNUAL_REVIEW || params[:application_type_id] == SbaApplication::ANNUAL_REVIEW

    return true if @sba_application.renewable? # check cert too?

    flash[:error] = "You must have an active certificate to renew"
    redirect_to vendor_admin_dashboard_index_path
    false
  end

  # if annual review, then find the duty station by the initial eight_a certificate
  def auto_assign_duty_station
    return unless @sba_application.kind == SbaApplication::ANNUAL_REVIEW && @sba_application.type == "SbaApplication::EightAAnnualReview"
    active_certificate = @sba_application.certificate
    initial_duty_stations = SbaApplication.find_by!(certificate_id: active_certificate.id, type: 'SbaApplication::EightAMaster').duty_stations
    @sba_application.duty_stations << initial_duty_stations unless initial_duty_stations.nil?
  end

  def set_organization
    @organization = current_user.organizations.find(organization_params)
  end

  def organization_params
    params.require(:organization_id)
  end

  def master_app_id
    params.require(:master_application_id)
  end

  def master_section_id
    params.require(:section_id)
  end

  def certificate_params
    params.require(:certificate_type_id)
  end

  def questionnaire_params
    params.require(:questionnaire_id)
  end

  def sba_application_id
    params.require(:id)
  end
end
