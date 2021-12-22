class Section
  class ReviewSectionsController < BaseController
    def edit
      @questionnaire_id = params[:questionnaire_id]
      @answer_proxy = @sba_application.answers
      if disqualified? && ! @questionnaire.displays_disqualifiers_inline?
        @sba_application.disqualify!
        @disqualifiers = @sba_application.disqualified_questions
        @section_name  = @disqualifiers.first.section.name
        @disqualifiers = @disqualifiers.map(&:disqualifier)
        render :disqualified
      elsif @sba_application.answered_every_section?
        @sections = @sba_application.get_answerable_section_list
        @user = current_user

        load_business_partners

        super
      else
        @unanswered_sections = @sba_application.unanswered_sections

        flash.now[:error] = "Some required sections were not answered"
        render :unanswered
      end
    end

    def update
      if @sba_application.answered_every_section?
        super
      else
        flash[:error] = "Error: Something went wrong, some sections are not answered, check with support team"
        redirect_to vendor_admin_dashboard_index_path
      end
    end

    private

    def set_questionnaire_layout
      super unless disqualified? && @questionnaire.has_questionnaire_layout?
    end

    def disqualified?
      @sba_application.has_disqualifying_answers? && ! params[:edit_disqualified]
    end
  end
end
