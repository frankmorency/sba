class Section
  class QuestionSectionsController < BaseController
    before_action :set_real_estate_type, only: [:edit, :update]


    def edit
      if params[:id] == 'signature'
        redirect_to edit_sba_application_questionnaire_signature_section_path(
                        @sba_application, @sba_application.questionnaire, 'signature'
                    )
      else

        setup_q_and_a current_user.try(:sba_analyst_wosb?) ? current_organization.default_user : nil

        super
      end
    end

    def update
      unless @user.answers_set?
        if @sba_application.is_a?(SbaApplication::SubApplication)
          section = Section::SubApplication.order('created_at desc').find_by(sub_application_id: @sba_application.id)
        else
          section = nil
        end

        @user.update_answers answer_params, @sba_application, section
      end

      super
    end

    def answer_params
      params.require(:answers)
    end

    def sort_column
      Document.sort_column(params[:sort])
    end

    protected

    def setup_q_and_a(user = nil)
      @questions = @section.question_presentations.joins(section: [], question: :question_type)

      @questions.each do |question|
        answer = get_answer(question)
        if answer
          question.value = answer.display_value.is_a?(Hash) ? answer.display_value.to_json : answer.display_value
          question.comment = answer.comment
          question.details = answer.details.to_json
        end
      end unless anonymous_questionnaire?

      @js_validation_settings = javascript_options.to_json
    end

    def get_answer(question)
      question.current_answer(@sba_application, @answered_for, current_user)
    end
  end
end
