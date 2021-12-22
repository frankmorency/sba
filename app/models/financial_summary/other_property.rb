class FinancialSummary
  class OtherProperty < Base
    attr_accessor :contributor, :app

    def initialize(contributor, app)
      @contributor =  contributor
      @app = app
      super(contributor, app)

      if present?
        @answers = contributor.answer_for(:other_personal_property, app.id).details&.values || []
      end
    end

    def present?
      return false unless contributor.answer_for(:other_personal_property, app.id)

      contributor.answer_for(:other_personal_property, app.id).value['value'].downcase == 'yes'
    end
  end
end
