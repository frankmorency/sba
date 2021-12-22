class Section
  class RepeatingQuestionSectionsController < QuestionSectionsController
    def edit
      super

      # why do i have to do this?
     # @questions.last.details = @questions.last.details && JSON.parse(@questions.last.details)
    end

    def update
      answer_params.each do |k, v|
        answer_params[ k ]['value'] = 'complicated'
      end

      super
    end
  end
end
