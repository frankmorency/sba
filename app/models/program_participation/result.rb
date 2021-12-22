module ProgramParticipation
  class Result
    def title
      case dashboard_display_app.try(:questionnaire).try(:name)
      when 'eight_a_migrated'
        'BDMIS Archive'
      when 'eight_a_initial'
        '8(a) Initial Application'
      when 'eight_a_annual_review'
        '8(a) Annual Review'
      else
        certificate_type.initial_questionnaire.link_label
      end
    end

    def formatted_expiry_date
      return nil unless expiry_date && !ineligible?
      expiry_date.strftime("%m/%d/%Y")
    end

    def display_decision
      return nil unless decision
      decision.titleize
    end
  end
end
