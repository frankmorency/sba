module Reviews
  class BaseController < Program::BaseController
    before_action   :set_review
    before_action   :set_app_from_review
    before_action   :set_organization_from_app

    layout 'application'

    protected

    def set_review
      @review = Review.find_by(case_number: params[:review_id])
    end

    def set_app_from_review
      if @review&.is_out_of_cycle?
        @sba_application = @review
      else
        @sba_application = @review ? @review.sba_application : SbaApplication.find(params[:sba_application_id])
      end
    end

    def set_organization_from_app
      @organization = @sba_application.organization
    end

    def ensure_non_terminal_cert
      if @review&.is_out_of_cycle? && @organization.has_terminal_8a_cert?
        flash[:info] = "This action cannot be taken when a certificate is in a terminal state."
        redirect_back_or_default
      end
    end
  end
end
