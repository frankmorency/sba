module SbaApplicationWorkflow
  extend ActiveSupport::Concern

  included do
    WORKFLOW_STATE_NAMES = {
        'draft' => 'Draft',
        'submitted' => 'Submitted',
        'under_review' => 'Under Review',
        'complete' => 'Complete',
        'inactive' => 'Inactive'
    }

    workflow do
      state :draft do
        event :submit, transition_to: :submitted
        event :return_for_modification, transition_to: :under_review
      end
      state :submitted do
        event :reopen, transition_to: :draft
        event :assign, transition_to: :under_review
        event :finalize_voluntary_withdrawal, transition_to: :complete
        event :finalize_early_graduation, transition_to: :complete
        event :finalize_termination, transition_to: :complete
      end
      state :under_review do
        event :cancel_review, transition_to: :submitted

        event :propose_ineligible, transition_to: :under_review
        event :propose_eligible, transition_to: :under_review

        event :unassign, transition_to: :under_review
        event :assign, transition_to: :under_review

        event :return_for_modification, transition_to: :inactive

        event :determination_made_decline_ineligible, transition_to: :complete
        event :determination_made_sba_approved, transition_to: :complete

        event :finalize_voluntary_withdrawal, transition_to: :complete
        event :finalize_early_graduation, transition_to: :complete
        event :finalize_termination, transition_to: :complete
      end
      state :complete
      state :inactive

      # This is a hack to force workflow to update via the active record stack rather than
      # straight SQL used by the update_column method provide. This feild is then reset by
      # the observer at ElasticObserver.rb
      after_transition do
        self.update_attributes(workflow_dirty: true)
      end
    end
  end
end
