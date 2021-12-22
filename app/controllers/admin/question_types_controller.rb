module Admin
  class QuestionTypesController < BaseController
    def index
      @grouped_question_types = QuestionType.all.group_by(&:type)
    end
  end
end
