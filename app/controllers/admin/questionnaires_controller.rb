module Admin
  class QuestionnairesController < BaseController
    def index
      @questionnaires = Questionnaire.includes(:root_section).all
    end
  end
end
