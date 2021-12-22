module SbaAnalyst
  class SignatureReviewsController < SbaAnalystController
    before_action   :setup_review
    before_action   :load_business_partners, if: :load_business_partners_pre_requirements

    def new
      if @review
        @signature_section = @review.sba_application.signature_section
        @sba_application = @review.sba_application

        @assessments = @signature_section.assessments
        @assessment = @signature_section.assessments.build(assessed_by: current_user, the_assessed_type: 'Section')
        @assessment.the_assessed_id = @signature_section.id
        @assessment.valid? # set the initial status
      else
        flash[:error] = 'You must initiate a case review first'
        redirect_to new_sba_analyst_sba_application_review_path(@sba_application)
      end

      render_read_only if !@sba_application.is_current? || @review.determination_made? || @review.returned_for_modification?
    end
  end
end
