module SbaAnalyst
  class AssessmentsController < SbaAnalystController
    before_action :set_review
    before_action :load_business_partners_pre_requirements

    def create
      ensure_application_is_current(@review.sba_application) || return

      if params[:assessments]
        params[:assessments].each do |ass_params|
          assessment = @review.assessments.build(assessed_by: current_user, status: ass_params[:status])
          assessment.the_assessed_id = ass_params[:the_assessed_id]
          assessment.the_assessed_type = ass_params[:the_assessed_type]
          assessment.note_body = ass_params[:note_body]
          assessment.review_id = @review.id
          if change_made?(assessment, ass_params[:original_status])
            assessment.save!
          end
        end

        flash[:notice] = 'Your assessments have been saved'
      else
        @assessment = @review.assessments.build(ass_params.merge(assessed_by: current_user))
        @assessment.the_assessed_type = params[:assessment][:the_assessed_type]
        @assessment.the_assessed_id = params[:assessment][:the_assessed_id]
        @assessment.note_body = params[:assessment][:note_body]
        @assessment.review_id = @review.id
        if change_made?(@assessment, params[:assessment][:original_status])
          if @assessment.save
            flash[:notice] = 'Your assessment has been saved'
          else
            flash[:error] = "There was a problem saving your assessment: #{@assessment.errors.full_messages.join(', ')}"
          end
        end
      end

      current_step = Rails.application.routes.recognize_path(request.referrer)[:controller]
      ordered_answered_for_ids = @owners.order(:answered_for_id).map{|owner| owner.answered_for_id} if @owners
      current_answered_for_id = params[:owner] if params[:owner]

      redirect_to next_analyst_review_step(current_step, @review, ordered_answered_for_ids, current_answered_for_id.to_i)
    end

    private

    def change_made?(assessment, status)
     ! (assessment.note_body.nil? && status == assessment.status)
    end

    def ass_params
      params.require(:assessment).permit(:the_assessed_type, :the_assessed_id, :status)
    end
  end
end
