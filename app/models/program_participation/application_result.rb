module ProgramParticipation
  class ApplicationResult < Result
    attr_accessor :app

    delegate  :first_section, to: :app
    delegate  :progress, to: :app
    delegate  :is_open?, to: :app
    delegate  :is_under_reconsideration?, to: :app
    delegate  :is_wosb?, to: :app
    delegate  :is_annual?, to: :app
    delegate  :link_label, to: :app
    delegate  :id, to: :app
    delegate  :decision, to: :app
    delegate  :deleteable?, to: :app
    delegate  :last_reconsideration_section, to: :app
    delegate  :current_review, to: :app
    delegate  :is_initial?, to: :app
    delegate  :is_eight_a_master_application?, to: :app
    delegate  :other_initial_master_apps_complete?, to: :app
    delegate  :creator, to: :app
    delegate  :master_application_id, to: :app
    delegate  :workflow_state, to: :app

    def initialize(app)
      @app = app
    end

    def pending_reconsideration_or_appeal?
      current_review&.pending_reconsideration_or_appeal?
    end

    def is_mpp_annual_report?
      app.is_mpp_annual_report?
    end

    def is_mpp_initial_complete?
      app.is_mpp_initial_complete?
    end

    def in_appeal?
      app.workflow_state == 'draft' && app&.current_review&.workflow_state == 'appeal'
    end

    def is_reconsidering?
      app.is_eight_a_master_application? && app.has_reconsideration_sections_and_ineligible_certificate?
    end

    def current_section
      if app.progress['current'].blank?
        app.first_section
      else
        Section.find_by(name: app.progress['current'].to_s, sba_application_id: app.id)
      end
    end

    def display_kind
      app.kind.titleize
    end

    def display_status
      return 'Updates needed' if app.updates_needed?
      return 'Active' if app.current_review && app.current_review.workflow_state == 'retained'
      return 'Ineligible' if app.current_review&.closed_automatically?
      return 'BDMIS Rejected' if app.certificate&.workflow_state == 'bdmis_rejected'
      return 'Closed' if app.workflow_state == 'complete'
      return app.certificate.display_status if (app.current_review && app.current_review.workflow_state == 'appeal_intent')
      app.status
    end

    def formatted_submission_date
      app&.application_submitted_at&.strftime("%m/%d/%Y")
    end
  end
end
