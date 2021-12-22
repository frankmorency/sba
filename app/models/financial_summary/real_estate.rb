class FinancialSummary
  class RealEstate < Base
    attr_accessor :contributor, :app

    def initialize(contributor, app)
      super(contributor, app)
      @contributor =  contributor
      @app = app
      @answers = []

      if has_primary?
        @answers += contributor.answer_for(:primary_real_estate, app.id)&.details || []
      end

      if has_other?
        @answers += contributor.answer_for(:other_real_estate, app.id)&.details || []
      end
    end

    def has_primary?
      return false unless contributor.answer_for(:has_primary_real_estate, app.id)

      contributor.answer_for(:has_primary_real_estate, app.id).value['value'].downcase == 'yes'
    end

    def has_other?
      return false unless contributor.answer_for(:has_primary_real_estate, app.id)

      contributor.answer_for(:has_primary_real_estate, app.id).value['value'].downcase == 'yes'
    end

    def present?
      has_primary? || has_other?
    end
  end
end
