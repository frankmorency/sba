module Admin
  class QuestionsController < BaseController
    def index
      @questions = QuestionPresentation.where('sections.sba_application_id IS NULL').
          joins(question: [:question_type], section: [:questionnaire]).
          sba_search(
              params[:search_input],
              page: params[:page],
              sort: {
                  column: params[:sort],
                  direction: sort_direction
              })
    end

    def sort_column
      QuestionPresentation.sort_column(params[:sort])
    end
  end
end
