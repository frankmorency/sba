module ProgramParticipation
  class CertificateResult < Result
    attr_accessor :certificate

    delegate :id, to: :certificate
    delegate :is_8a?, to: :certificate
    delegate :doc_upload?, to: :certificate
    delegate :inactive?, to: :certificate
    delegate :ineligible?, to: :certificate
    delegate :is_under_reconsideration?, to: :certificate
    delegate :needs_annual_report?, to: :certificate
    delegate :renewable?, to: :certificate
    delegate :initial_app, to: :certificate
    delegate :current_application, to: :certificate
    delegate :expiry_date, to: :certificate
    delegate :certificate_type, to: :certificate
    delegate :status, to: :certificate
    delegate :decision, to: :certificate
    delegate :dashboard_display_app, to: :certificate
    delegate :finalized?, to: :certificate
    delegate :workflow_state, to: :certificate
    delegate :issue_date, to: :certificate

    def initialize(cert)
      @certificate = cert
    end

    def title
      return "8(a) Document Upload" if doc_upload?

      super
    end

    def visible_to_vendor?
      return false if certificate.intend_to_appeal
      return false if certificate.application_in_draft? && certificate.application_in_reconsideration_process
      return false if certificate.workflow_state == "closed"
      return false if certificate.workflow_state == "bdmis_rejected"
      true
    end

    def display_kind
      "Certificate"
    end

    def display_status
      if certificate.current_application(SbaApplication::INITIAL)&.updates_needed?
        "Updates needed"
      else
        status
      end
    end

    def formatted_submission_date
      return nil unless current_application&.application_submitted_at
      current_application.application_submitted_at.strftime("%m/%d/%Y")
    end
  end
end
