module SbaAnalyst
  class DeterminationsController < SbaAnalystController
    before_action   :set_review
    before_action   :set_analysts, only: [:new, :edit]
    before_action   :load_business_partners, if: :load_business_partners_pre_requirements
    before_action   :authorize_determination_change, only: [:create, :update], if: :is_eight_a_program
    
    def new
      @determination = @review.determination

      if @determination
        redirect_to edit_sba_analyst_review_determination_path(@review, @determination)
        return
      else
        @determination = @review.build_determination
        @assessments = @review.assessments.load.select(&:persisted?)
        @assessment = @review.assessments.build
        @sba_application = @review.sba_application
        @user = current_user
      end

      render_read_only if !@sba_application.is_current? || @review.determination_made? || @review.returned_for_modification?
    end

    def create
      ensure_application_is_current(@review.sba_application) || return

      @review.update_determination!(
          current_user,
          params[:review][:workflow_state],
          params[:original_reviewer_id],
          params[:reviewer_id],
          params[:determination],
          assessment_params
      )
      if params[:original_reviewer_id] != params[:reviewer_id]
        ApplicationController.helpers.log_activity_application_event('reviewer_changed', @sba_application.id, current_user.id, params[:reviewer_id])
      end

      redirect_to :back
    end

    def edit
      @determination = @review.determination
      @assessments = @review.assessments.load.select(&:persisted?)
      @assessment = @review.assessments.build
      @sba_application = @review.sba_application
      @user = current_user

      render_read_only if !@sba_application.is_current? || @review.determination_made? || @review.returned_for_modification?
    end

    def update
      ensure_application_is_current(@review.sba_application) || return

      @review.update_determination!(
          current_user,
          params[:review][:workflow_state],
          params[:original_reviewer_id],
          params[:reviewer_id],
          params[:determination],
          assessment_params
      )
      if params[:original_reviewer_id] != params[:reviewer_id]
        ApplicationController.helpers.log_activity_application_event('reviewer_changed', @sba_application.id, current_user.id, params[:reviewer_id])
      end

      redirect_to :back
    end

    private

    def assessment_params
      params.require(:assessment).permit(:note_body)
    end

    def authorize_determination_change
      if params[:determination] && params[:determination][:decision].to_i == 0 || params[:determination] && params[:determination][:decision].to_i == 1
        user_not_authorized unless current_user.can?(:make_case_review_determination)
      end
    end
  end
end