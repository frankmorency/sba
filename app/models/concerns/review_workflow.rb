module ReviewWorkflow
  extend ActiveSupport::Concern

  included do
    REVIEW_STATES = %w( assigned_in_progress returned_for_modification recommend_eligible recommend_ineligible determination_made pending_reconsideration_or_appeal appeal reconsideration )

    NON_8A_REVIEW_STATES = %w(assigned_in_progress returned_for_modification recommend_eligible recommend_ineligible determination_made)

    DISPLAYABLE_REVIEW_STATES = REVIEW_STATES

    REVIEW_EVENTS = %w(assign return_for_modification propose_ineligible propose_eligible)

    DECISION_EVENTS = %w(determination_made_decline_ineligible determination_made_sba_approved)

    STATE_TO_EVENT = {
        'assigned_in_progress' => 'assign',
        'returned_for_modification' => 'return_for_modification',
        'recommend_ineligible' => 'propose_ineligible',
        'recommend_eligible' => 'propose_eligible'
    }

    DECISION_TO_EVENT = {
        'decline_ineligible' => 'determination_made_decline_ineligible',
        'sba_approved' => 'determination_made_sba_approved'
    }

    STATE_LABELS = {
        'assigned_in_progress' => 'Review Started',
        'returned_for_modification' => 'Return for Modification',
        'recommend_ineligible' => 'Recommend Ineligible',
        'recommend_eligible' => 'Recommend Eligible',
        'determination_made' => 'Determination Made',
        'pending_reconsideration_or_appeal' => "Pending Appeal",
        'appeal_intent' => 'Appeal Intent',
        'reconsideration' => 'Reconsideration'
    }

    workflow do
      state :assigned_in_progress do
        event :return_for_modification, transition_to: :returned_for_modification
        event :propose_ineligible, transition_to: :recommend_ineligible
        event :propose_eligible, transition_to: :recommend_eligible
        event :determination_made_sba_approved, transition_to: :determination_made
        event :determination_made_decline_ineligible, transition_to: :determination_made
        event :cancel, transition_to: :cancelled
      end

      state :returned_for_modification

      state :recommend_eligible do
        event :assign, transition_to: :assigned_in_progress
        event :return_for_modification, transition_to: :returned_for_modification
        event :propose_ineligible, transition_to: :recommend_ineligible
        event :determination_made_sba_approved, transition_to: :determination_made
        event :determination_made_decline_ineligible, transition_to: :determination_made
        event :cancel, transition_to: :cancelled
      end

      state :recommend_ineligible do
        event :assign, transition_to: :assigned_in_progress
        event :return_for_modification, transition_to: :returned_for_modification
        event :propose_eligible, transition_to: :recommend_eligible
        event :determination_made_sba_approved, transition_to: :determination_made
        event :determination_made_decline_ineligible, transition_to: :determination_made
        event :cancel, transition_to: :cancelled
      end

      state :early_graduated do
        on_entry do
          remove_current_assignment
        end
      end

      state :terminated do
        on_entry do
          remove_current_assignment
        end
      end

      state :voluntary_withdrawn do
        on_entry do
          remove_current_assignment
        end
      end

      state :cancelled
      state :withdrawn
      state :determination_made

      # This is a hack to force workflow to update via the active record stack rather than
      # straight SQL used by the update_column method provide. This feild is then reset by
      # the observer at ElasticObserver.rb
      after_transition do
        self.update_attributes(workflow_dirty: true)
      end
    end
  end

  def assign
    sba_application.assign!
    certificate.assign!
  end

  def return_for_modification
  end

  def propose_eligible
    sba_application.propose_eligible!
    certificate.propose_eligible!
  end

  def propose_ineligible
    sba_application.propose_ineligible!
    certificate.propose_ineligible!
  end

  def determination_made_sba_approved
    sba_application.determination_made_sba_approved!
    certificate.determination_made_sba_approved!
  end

  def determination_made_decline_ineligible
    sba_application.determination_made_decline_ineligible!
    certificate.determination_made_decline_ineligible!
  end

  def cancel
    sba_application.cancel_review!
    certificate.cancel_review!
  end
end
