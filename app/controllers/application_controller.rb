class ApplicationController < ActionController::Base
  include ApplicationHelper

  helper_method :sort_column, :sort_direction

  rescue_from Strategy::Answer::ValidationError, with: :answer_invalid

  rescue_from CanCan::AccessDenied do |exception|
    user_not_authorized
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_organization
  helper_method :eight_a_available?

  protect_from_forgery :with => :exception

  def render_read_only(full_page = true)
    @full_page = full_page
    @read_only = true
    render layout: "read_only"
  end

  def set_public_flag
    @public = true
  end

  def set_private_flag
    @public = false
  end

  def current_organization
    @organization || current_user.one_and_only_org
  end

  def test_exception_notifier
    raise "This is a test. Only a test."
  end

  def after_sign_in_path_for(resource)
    if can? :contribute, resource
      contributor = Contributor.find_by_email(resource.email.downcase)
      if contributor
        vendor_admin_dashboard_index_path
      else
        "/find_business"
      end
    elsif can? :request_access_to_vendor, resource
      contracting_officer_access_requests_path
    elsif can?(:ensure_ops_support, resource)
      ops_support_user_index_path
    elsif resource.max_id.nil? && resource.roles.empty?
      find_business_path
      # This is a gov user that does not have any roles
    elsif resource.max_id && resource.roles.empty?
      request_role_path
    elsif can? :sba_user, resource
      if Feature.inactive?(:elasticsearch)
        if can?(:ensure_mpp_user, current_user) || can?(:ensure_8a_user, current_user)
          all_cases_sba_analyst_cases_path
        elsif can? :ensure_8a_initial_sba_analyst, resource
          eight_a_initial_sba_analyst_dashboard_index_path
        elsif can? :ensure_8a_initial_sba_supervisor, resource
          eight_a_initial_sba_supervisor_dashboard_index_path
        else
          sba_analyst_cases_path
        end
      else
        if can? :ensure_8a_initial_sba_analyst, resource
          eight_a_initial_sba_analyst_dashboard_index_path
        elsif can? :ensure_8a_initial_sba_supervisor, resource
          eight_a_initial_sba_supervisor_dashboard_index_path
        elsif can? :assign_8a_role_district_office_supervisor, resource
          district_office_sba_supervisor_dashboard_index_path
        else
          sba_analyst_cases_path
        end
      end
    elsif can? :ensure_admin, resource
      admin_dashboard_index_path
    else
      vendor_admin_dashboard_index_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def configure_permitted_parameters
    if Feature.active?(:idp)
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :first_name, :last_name, :phone_number) }
    else
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name, :phone_number) }
    end
  end

  def pdf_view(folder_name, file_name, document_id = nil, organization_id = nil)
    data = Document.get_pdf_object(folder_name, file_name)
    gon.pdf_data = Document.encode_pdf_content_to_base64(data)
    @document_id = document_id
    @organization_id = organization_id
    render "documents/pdf_viewer", :layout => "blank"
  end

  def user_for_paper_trail
    current_user ? current_user.id : "Public User"  # or whatever
  end

  def sort_direction(param = nil)
    param = param ? param : params[:direction]
    %w[asc desc].include?(param) ? param : "asc"
  end

  def show_eight_a?
    Feature.active? :eight_a
  end

  def redirect_back_or_default(default_url = root_url)
    redirect_to (request.referer.present? ? :back : default_url)
  end

  protected

  def setup_review_permissions
    @review = @sba_application.current_review
    @permissions = Permissions.build(current_user, @review)
  end

  def check_eight_a_feature
    return true unless @questionnaire
    raise Error::FeatureUnavailable.new("Eight A Feature Not Available") if @questionnaire.eight_a? && !show_eight_a?
  end

  rescue_from ActionController::InvalidAuthenticityToken do
    redirect_to root_path
  end

  def authenticate_user!(options = {})
    super(options)
    if user_signed_in?
      super
    else
      redirect_to root_path
    end
  end

  def anonymous_questionnaire?
    @questionnaire.anonymous?
  end

  def ensure_max_user
    # Max.gov Users have a max_id populated
    current_user && current_user.max_id? ? true : user_not_authorized
  end

  # Use with max.gov id OR user with supervisor access
  def ensure_max_or_sba_supervisor
    if current_user.assign_role?
      true
    else
      user_not_authorized
    end
  end

  def ensure_sba_or_vendor
    if current_user.can_any? :ensure_vendor, :ensure_contributor
      @read_only = false
      set_current_organization
    elsif current_user.can_any? :sba_user, :ensure_ops_support
      @read_only = true
      @application = SbaApplication.find(sba_application_id)
      @organization = @application.organization
    else
      return user_not_authorized
    end

    true
  end

  def contributor_index
    contributors = Contributor.where(email: current_user.email).order(created_at: :desc)
    @contributors = []

    contributors.each do |contributor|
      @contributors << ProgramParticipation::ContributorInfo.new(current_user, contributor)
    end

    @info_requests = SbaApplication::EightAInfoRequest.where(creator: current_user)

    render template: "contributors/dashboard/index"
  end

  def ensure_contributor_can_access
    if current_user.can_any? :ensure_contributor
      #  prevent access to wosb & mpp apps
      if @sba_application.type == "SbaApplication::SimpleApplication"
        return user_not_authorized
      end
    end
    true
  end

  def ensure_application_admin
    return user_not_authorized unless current_user.can?(:ensure_admin)
  end

  def ensure_vendor_admin
    return user_not_authorized unless current_user.is_vendor?
  end

  def ensure_vendor_contributor
    return user_not_authorized unless current_user.is_contributor?
  end

  def ensure_sba_analyst
    raise "We are using Cancancan to do that now"
  end

  def ensure_user_can_assign_case
    return user_not_authorized unless current_user.has_any_role?(:sba_supervisor_8a_hq_aa, :sba_supervisor_8a_hq_program, :sba_supervisor_8a_cods, :sba_supervisor_8a_hq_ce, :sba_supervisor_8a_district_office, :sba_director_8a_district_office, :sba_deputy_director_8a_district_office)
  end

  def ensure_district_office_supervisor
    return user_not_authorized unless current_user.has_role?(:sba_supervisor_8a_district_office)
  end

  def ensure_sba_aa_deputy
    return user_not_authorized unless current_user.has_role?(:sba_supervisor_8a_hq_aa)
  end

  def ensure_sba_user
    return user_not_authorized unless current_user.is_sba?
  end

  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    redirect_to("/")
  end

  def set_current_organization
    if current_user.has_no_orgs?
      flash[:info] = "Please select at least one business to associate to your application."
      redirect_to "/find_business"
      return false
    else
      @organization = current_user.one_and_only_org
      unless @organization.is_active?
        flash[:error] = "Since you last logged in to certify.SBA.gov, your business has become inactive in SAM.gov. Please login to SAM.gov to reactivate your account. It may take up to 72 hours for the change in SAM.gov to be reflected on certify.SBA.gov."
        sign_out current_user
        redirect_to("/")
        return false
      end
    end

    true
  end

  def set_application
    if @organization
      @sba_application = @organization.sba_applications.find(sba_application_id)
    elsif current_organization
      @sba_application = current_organization.sba_applications.find(sba_application_id)
    else
      raise Error::DataManipulation.new("Applications must be scoped to an organization")
    end

    if [SbaApplication::SubApplication, SbaApplication::SimpleApplication].include?(@sba_application.class) && current_user.is_vendor_or_contributor?
      head(:unauthorized) unless current_user.can_view_answers?(@sba_application)
    end
  end

  def sba_application_id
    params.require(:sba_application_id)
  end

  def set_questionnaire
    @questionnaire = Questionnaire.get(questionnaire_params)
  end

  def set_section
    if @sba_application # am i eligible...
      @section = @sba_application.sections.find_by(name: section_id)
    else
      @section = @questionnaire.sections.find_by(name: section_id || params[:id])
    end

    @answered_for = @section.answered_for
  end

  def section_id
    params.require(:section_id)
  end

  def questionnaire_params
    params.require(:questionnaire_id)
  end

  # TODO: May be move to helper method?
  def load_business_partners
    @business_partner_summaries = []

    # check if spawner class is an applicable section
    is_spawner_applicable_section = false
    @sba_application.get_answerable_section_list.each do |sec|
      if sec.is_a?(Section::Spawner)
        is_spawner_applicable_section = true
        break
      end
    end

    if is_spawner_applicable_section && @sba_application.business_partners.any?
      @sba_application.business_partners.each do |partner|
        personal_summary = ::PersonalSummary.new(partner, @sba_application.has_agi?, @sba_application.id)
        @business_partner_summaries << {
          partner: partner,
          assets: personal_summary.assets.answers,
          liabilities: personal_summary.liabilities.answers,
          agi: personal_summary.agi.answers,
          income: personal_summary.income.answers,
        }
      end
    end

    @business_partner_summaries
  end

  def ensure_organization_user
    return true if @organization.users.include?(current_user)

    head :forbidden
    false
  end

  def not_in_production
    return false

    if Rails.env.production? || Rails.env.stage?
      head :forbidden
      false
    end

    true
  end

  def devise_or_pages_controller?
    devise_controller? || is_a?(PagesController) || is_a?(Custom::AmIEligibleController)
  end

  if Feature.active?(:idp)
    def set_session(user)
      session["devise.sba_idp_data"] = request.env["omniauth.auth"]
      session[:user_id] = user.id
    end

    def failure
      redirect_to root_path
    end
  end

  private

  def answer_invalid
    render "sba_applications/answer_invalid"
  end

  def review_params
    params.require(:review).permit(:type, current_assignment_attributes: [:supervisor_id, :reviewer_id, :owner_id, :id, :review_id])
  end
end
