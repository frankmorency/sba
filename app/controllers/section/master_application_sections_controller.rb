class Section
  class MasterApplicationSectionsController < BaseController
    before_action   :setup_review_permissions

    def edit
      @questions = []
      @questionnaire_layout = false
      @title = @sba_application.questionnaire.title
      @first_section = @sba_application.first_section

      #/sba_applications/2/questionnaires/eight_a_eligibility/question_sections/eight_a_basic_eligibility_screen/edit
      #/sba_applications/2/questionnaires/eight_a_eligibility/sub_applications/eight_a_eligibility/edit
      unless @sba_application.prerequisites_complete?
        sub_app = @sba_application.sub_application_sections.prerequisite.where('status != ?', Section::COMPLETE).first.sub_application
        current_section = sub_app.current_section || sub_app.first_section

        redirect_to "/sba_applications/#{sub_app.id}/questionnaires/#{sub_app.questionnaire.name}/#{current_section.underscore_type}/#{current_section.name}/edit"
        return
      end

      if current_user.can? :contribute
        @programs = Program.display_list
        @applications = current_organization.sba_applications.for_display.group_by(&:program)
        @contributor = current_user.contributor
        section, @sub_application, questionnaire_id = @contributor.details

        if @sub_application.nil?
          master_application_id = @contributor.sba_application.id
          section_id = @contributor.section_name
          @new_application_url = new_master_application_section_questionnaire_sba_application_path(master_application_id, section_id, questionnaire_id)
        end

        contributor_index
      else
        redirect_to sba_application_application_dashboard_overview_index_path(@sba_application.id)
      end
    end

    protected

    def get_progress
      SbaApplication::Progress.new(@sba_application, @user, @section)
    end

    def set_section
      @section = @sba_application.first_section
    end
  end
end
