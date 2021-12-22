class AdverseActionReviewsController < OutOfCycleReviewsController
  before_action   :ensure_non_terminal_cert, only: [:new, :create]

  def new
  end

  def create
    review = Review::AdverseAction.create_and_assign_review(current_user, @organization)

    if review
      flash[:notice] = 'You created an adverse action for SBA review. It is ready for internal processing.'
      redirect_to organization_adverse_action_review_path(@organization, review)
    else
      flash[:error] = 'There was a problem create the adverse action'
      redirect_to :back
    end
  end

  def show
    @sba_application = Review::AdverseAction.find_by(case_number: params[:id])
    @organization = @sba_application.organization
    @permissions = Permissions.build(current_user, @sba_application)
  end

  protected

  def ensure_non_terminal_cert
    if @organization.has_terminal_8a_cert?
      flash[:info] = "This action cannot be taken when a certificate is in a terminal state."
      redirect_back_or_default
    end
  end
end