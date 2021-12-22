module SbaAnalyst
  class ReviewsController < SbaAnalystController
    include ActivityLog
    before_action   :authorized?, only: [:new, :create]
    before_action   :set_application_open, only: [:new, :create, :approve, :decline, :return_to_vendor]
    before_action   :set_review_types, only: [:edit, :new]
    before_action   :set_review, only: [:edit, :update]
    before_action   :set_analysts, only: [:edit, :new]
    before_action   :load_business_partners, only: [:edit, :update], if: :load_business_partners_pre_requirements
    before_action   :set_activities, only: [:edit]

    def new
      @review = @sba_application.reviews.first
      @certificate = @sba_application.certificate
      @organization = @certificate.organization
      @first_section = @sba_application.first_section
      if @sba_application.sam_snapshot['duns'].blank?
        @sba_application.sam_snapshot = MvwSamOrganization.return_snapshot(@organization)
        @sba_application.save
      end

      if @review
        redirect_to edit_sba_analyst_review_path(@review)
        return
      else
        @review = @certificate.reviews.build
        @review.build_current_assignment

        if @sba_application.is_eight_a_master_application?
          prepare_app_for_viewing
          @permissions = Permissions.build(current_user)
          render 'eight_a_review'
        end
      end
    end

    def create
      ensure_application_is_current(@sba_application) || return

      @review = Review.factory(review_params.merge(certificate_id: @sba_application.certificate_id, sba_application_id: @sba_application.id))
      @review.save!
#
      @sba_application.assign!

      @review.current_assignment.update_attribute(:review_id, @review.id)

      # current_assignment_id is not getting set. Assigning it here.
      @review.update_attribute(:current_assignment_id, @review.assignments.last.id) if @review.assignments.count > 0

      redirect_to new_sba_analyst_review_question_review_path(@review)
    end

    def edit
      @organization = @sba_application.organization
      @assessments = Assessment.where(review_id: @review.id)

      if @sba_application.is_eight_a_master_application?
        prepare_app_for_viewing(false)
        @first_section = @sba_application.first_section
        @permissions = Permissions.build(current_user, @sba_application.current_review)
        render 'eight_a_review'
      end

      render_read_only if !@sba_application.is_current? || @review.determination_made? || @review.returned_for_modification?
    end

    def update
      ensure_application_is_current(@sba_application) || return
      @review.update_attributes(review_params)
      redirect_to new_sba_analyst_review_question_review_path(@review)
    end

    def show
    end

    def index
      raise "You should not be here yet"
      @reviews = @certificate.reviews
    end

    def destroy
      @review = Review.find(params[:id])
      @review.reset
      redirect_to sba_analyst_dashboard_show_path(enc: $encryptor.encrypt("duns_number=#{@review.certificate.organization.duns}&tax_identifier=#{@review.certificate.organization.tax_identifier_number}"))
    end

    private

    def set_review_types
      @review_types = Review::REVIEW_TYPES.invert
    end

    def authorized?
      return user_not_authorized unless current_user.can? :start_review
    end
  end
end
