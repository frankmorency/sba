class CasesIndex < Chewy::Index
  define_type Certificate.where.not(workflow_state: 'inactive').includes(:sba_applications, :organization, :certificate_type) do
    field :business_name, value: -> (certificate) {certificate.organization.legal_business_name}
    field :business_id, value: -> (certificate) {certificate.organization.id}
    field :duns, value: -> (certificate) {certificate.organization.duns_number}
    field :program, value: -> (certificate) {certificate.certificate_type.super_short_name}
    field :program_title, value: -> (certificate) {certificate.certificate_type.title}
    field :review_type, value: -> (certificate) do
      cert_type = nil
      if certificate.current_review
        review = certificate.current_review
        type = review.class.name
        case type
          when 'Review::Annual'
            cert_type = 'annual_review'
          when 'Review::Initial'
            cert_type = 'initial_review'
          else
            cert_type = nil
        end
      end
      cert_type
    end
    field :review_type_humanized, value: -> (certificate) do
      cert_type = nil
      if certificate.current_review
        review = certificate.current_review
        type = review.class.name
        case type
          when 'Review::Annual'
            cert_type = 'Annual Review'
          when 'Review::Initial'
            cert_type = 'Initial Review'
          else
            cert_type = nil
        end
      end
      cert_type
    end
    # "03/21/2017"
    field :submitted_date, value: -> (certificate) {certificate.current_application.formatted_submission_date}
    # Tue, 21 Mar 2017 22:15:34 UTC +00:00
    field :date_submitted, type: 'date', value: -> (certificate) {certificate.current_application.application_submitted_at}
    field :owner, type: 'string', index: 'not_analyzed', value: -> (certificate) {certificate.current_review.current_assignment.owner.name if certificate.current_review && certificate.current_review.current_assignment && certificate.current_review.current_assignment.owner}
    field :reviewer, type: 'string', index: 'not_analyzed', value: -> (certificate) {certificate.current_review.current_assignment.reviewer.name if certificate.current_review && certificate.current_review.current_assignment && certificate.current_review.current_assignment.reviewer}
    field :status, value: -> (certificate) do
      certificate.workflow_state
    end
    field :status_humanize, value: -> (certificate) do
      certificate.display_status
    end
    field :ein, value: -> (certificate) {certificate.organization.tax_identifier}
    field :certificate_id, value: -> (certificate) { certificate.id }
    field :determination, value: -> (certificate) do
      if certificate.current_review && certificate.current_review.determination && certificate.current_review.determination.decision
        certificate.current_review.determination.decision
      end
    end
    field :determination_humanized, value: -> (certificate) do
      if certificate.current_review && certificate.current_review.determination && certificate.current_review.determination.decision
        certificate.current_review.determination.display_decision
      end
    end
    field :recommendation, value: -> (certificate) do
      if certificate.current_review && certificate.current_review.workflow_state
        certificate.current_review.workflow_state
      end
    end
    field :recommendation_humanized, value: -> (certificate) do
      if certificate.current_review && certificate.current_review.workflow_state
        certificate.current_review.display_status
      end
    end
  end
end
