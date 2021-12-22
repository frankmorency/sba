class SbaAnalystController < ApplicationController
  include ReviewsHelper

  before_action :authenticate_user!
  before_action :require_sba_analyst

  protected

  def set_application_open
    if current_organization
      @sba_application = current_organization.sba_applications.find(sba_application_id)
    elsif current_user.can? :view_vendor_certification
      @sba_application = SbaApplication.find(sba_application_id)
    else
      raise Error::DataManipulation.new("Applications must be scoped to an organization")
    end
  end

  def ensure_mpp_analyst
    current_user.can? :ensure_mpp_user
  end

  def is_eight_a_program
    @review.sba_application.program.name == 'eight_a'
  end

  def prepare_app_for_viewing(set_app = true)
    if can? :view_vendor_application, current_user
      @organization = Organization.find(@sba_application.organization_id)
      @user = @organization.default_user
    else
      return unless set_current_organization
      @user = current_user
    end

    set_application if set_app

    @sections = @sba_application.get_answerable_section_list
    @answer_proxy = @sba_application.answers #.where({sba_application_id: @sba_application.id})

    load_business_partners
  end

  def ensure_application_is_current(app)
    return true if app.is_current?

    flash[:error] = 'A newer version of the application has been created.'
    redirect_to new_sba_analyst_sba_application_review_path(app.current_sba_application)

    false
  end

  def certificate_params
    params.require(:certificate_id)
  end

  def determination_params
    params.require(:determination).permit(:decision, :decider_id, :eligible)
  end

  def set_certificate
    @certificate = Certificate.find(certificate_params)
  end

  def set_analysts
    type = @certificate ? @certificate.certificate_type.name : @sba_application.certificate_type.name

    case type
      when 'wosb', 'edwosb'
        @analysts = User.with_any_role(:sba_analyst_wosb, :sba_supervisor_wosb).map {|user| [user.name, user.id]}
      when 'mpp'
        @analysts = User.with_any_role(:sba_analyst_mpp, :sba_supervisor_mpp).map {|user| [user.name, user.id]}
    end
  end

  def set_review
    if @certificate
      @review = @certificate.reviews.find_by(case_number: params[:review_id] || params[:id])
    else
      @review = Review.find_by(case_number: params[:review_id] || params[:id])
      @sba_application = @review.sba_application
    end
  end

  def require_sba_analyst
    user_not_authorized unless (current_user.is_sba?)
  end

  def setup_review
    set_review
    # TODO: We actually need to capture signatures and store them with the cert...
    # This means that the signatory could be different from who actually signed if there are multiple users for the org
    @organization = @certificate ? @certificate.organization : @sba_application.organization
    @signatory = @organization.default_user
    @signature_terms = Signature.new(@sba_application.questionnaire).terms
    @statuses = Assessment::STATUSES
  end

  def load_business_partners_pre_requirements
    if @review
      @sba_application = @review.sba_application

      # Gets business partners (from the application)
      if @sba_application.has_financial_section?
        @owners = @sba_application.financial_section.children
        return true
      end
    end
    return false
  end
end
