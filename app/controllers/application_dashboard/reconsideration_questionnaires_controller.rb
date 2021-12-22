module ApplicationDashboard
  class ReconsiderationQuestionnairesController < BaseController
    before_action :set_sub_application

    def index
      @reconsideration_sections = @sba_application.sections.find_by(sub_application_id: @sub_application.id).reconsideration_sections
      @master_application = @sba_application
      @sba_application = @sub_application
    end

    def appeal_or_reconsideration
    end

    def appeal_or_reconsider
      if params["when_declined_choice"] == "reconsideration"
        current_section = @sub_application.current_section || @sub_application.first_section
        redirect_to "/sba_applications/#{@sub_application.id}/questionnaires/#{@sub_application.questionnaire.name}/#{current_section.underscore_type}/#{current_section.name}/edit"
      else
        redirect_to intend_to_appeal_sba_application_application_dashboard_sub_application_reconsideration_questionnaires_path(@sba_application, @sub_application)
      end
    end

    def intend_to_appeal
    end

    def intent_acknowledgment
      if params["confirm_intent_checkbox"]
        @sba_application.try(:current_review).user_submit_appeal_intent!
        @sub_application.appeal_intent_selected!
      else
        flash[:alert] = 'Please indicate your intent to appeal by selecting the checkbox below.'
        redirect_to intend_to_appeal_sba_application_application_dashboard_sub_application_reconsideration_questionnaires_path(@sba_application, @sub_application)
      end
    end

    def appeal_reminder
    end

  end
end
