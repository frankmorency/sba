class Section
  class CompositeQuestionSectionsController < QuestionSectionsController

    def update
      answer_params.each do |k, v|
        answer_params[ k ]['value'] = 'complicated'
      end

      super
    end
  end
end
