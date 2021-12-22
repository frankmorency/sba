# DO WE HAVE INELIGIBLE CERTS?

module CertificateWorkflow
  extend ActiveSupport::Concern

  included do
    TERMINAL_STATES = [:early_graduated, :terminated, :voluntary_withdrawn, :graduated]
    FINALIZED_STATES = [:early_graduated, :terminated, :voluntary_withdrawn]
    NON_ACTIVE_STATES = [:early_graduated, :graduated, :terminated, :withdrawn, :bdmis_rejected] + FINALIZED_STATES

    workflow do

      state :pending do
        event :cancel_review, transition_to: :pending
        event :assign, transition_to: :pending
        event :propose_eligible, transition_to: :pending
        event :propose_ineligible, transition_to: :pending
        event :determination_made_sba_approved, transition_to: :active
        event :activate_for_bdmis, transition_to: :active
        event :determination_made_decline_ineligible, transition_to: :ineligible
        event :deactivate, transition_to: :inactive
        event :review_closed, transition_to: :closed
        event :finalize_voluntary_withdrawal, transition_to: :voluntary_withdrawn
        event :finalize_early_graduation, transition_to: :early_graduated
        event :finalize_termination, transition_to: :terminated
      end

      state :active do
        event :cancel_review, transition_to: :pending
        event :assign, transition_to: :pending
        event :propose_eligible, transition_to: :pending
        event :propose_ineligible, transition_to: :pending
        event :determination_made_sba_approved, transition_to: :active
        event :determination_made_decline_ineligible, transition_to: :ineligible
        event :deactivate, transition_to: :inactive
        event :expire, transition_to: :expired
        event :review_closed, transition_to: :closed
        event :finalize_voluntary_withdrawal, transition_to: :voluntary_withdrawn
        event :finalize_early_graduation, transition_to: :early_graduated
        event :finalize_termination, transition_to: :terminated
      end

      state :inactive do
        event :deactivate, transition_to: :inactive
        event :activate, transition_to: :pending
        event :finalize_voluntary_withdrawal, transition_to: :voluntary_withdrawn
        event :finalize_early_graduation, transition_to: :early_graduated
        event :finalize_termination, transition_to: :terminated
      end

      # HAVE THEY JUST NOT MARKED CERTS INELIGIBLE???
      state :ineligible do
        event :determination_made_decline_ineligible, transition_to: :ineligible # when reconsideration is denied
        event :determination_made_sba_approved, transition_to: :active # when reconsideration approved
        event :review_closed, transition_to: :closed
        event :finalize_voluntary_withdrawal, transition_to: :voluntary_withdrawn
        event :finalize_early_graduation, transition_to: :early_graduated
        event :finalize_termination, transition_to: :terminated
      end

      state :expired do
        event :review_closed, transition_to: :closed
        event :finalize_voluntary_withdrawal, transition_to: :voluntary_withdrawn
        event :finalize_early_graduation, transition_to: :early_graduated
        event :finalize_termination, transition_to: :terminated
      end

      state :closed do
        event :make_ineligible, transition_to: :ineligible
        event :review_closed, transition_to: :closed
      end

      state :early_graduated
      state :terminated
      state :voluntary_withdrawn
      state :graduated
      state :withdrawn
      state :bdmis_rejected

      # This is a hack to force workflow to update via the active record stack rather than
      # straight SQL used by the update_column method provide. This field is then reset by
      # the observer at ElasticObserver.rb
      after_transition do
        self.update_attributes(workflow_dirty: true)
      end
    end
  end

  def skip_pending_for_wosb_application
  end

  def assign
  end

  def propose_eligible
  end

  def propose_ineligible
  end

  def determination_made_sba_approved
  end

  def determination_made_decline_ineligible
  end
end
