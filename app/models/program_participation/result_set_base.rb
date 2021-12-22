module ProgramParticipation
  class ResultSetBase
    attr_accessor :organization, :current_user

    def initialize(org, user)
      @organization, @current_user = org, user
    end

    def annual_reports
      []
    end

    def empty?
      certificates.empty? && applications.empty? && annual_reports.empty?
    end

    def certificates
      organization.displayable_certificates.joins(:certificate_type).where("certificate_types.name = ?", program.name).map { |cert| ProgramParticipation::CertificateResult.new(cert) }
    end

    def applications
      organization.sba_applications.for_display.joins(questionnaire: :program).where("programs.name = ?", program.name).reject { |app| app.creator_id != current_user.id && app.info_request? }.map { |app| ProgramParticipation::ApplicationResult.new(app) }
    end

    def applications_without_info_requests
      organization.sba_applications.for_display.joins(questionnaire: :program).where("programs.name = ?", program.name).reject { |app| app.creator_id != current_user.id || app.info_request? }.map { |app| ProgramParticipation::ApplicationResult.new(app) }
    end

    def info_requests
      organization.sba_applications.for_display.joins(questionnaire: :program).where("programs.name = ?", program.name).reject { |app| app.certificate&.workflow_state == "ineligible" }.select { |app| app.type == "SbaApplication::EightAInfoRequest" }
    end

    def certificate_states
      certificates.reject { |cert| !cert.visible_to_vendor? }.map { |certificate| certificate.workflow_state }
    end

    def application_states
      applications_without_info_requests.reject { |app| app.in_appeal? || app.is_mpp_initial_complete? }.map { |app| app.workflow_state }
    end

    def displayable_states
      certificate_states
    end
  end
end
