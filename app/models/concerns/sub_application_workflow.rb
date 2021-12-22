module SubApplicationWorkflow
  extend ActiveSupport::Concern

  included do
    WORKFLOW_STATE_NAMES = {
      'draft' => 'Draft',
      'submitted' => 'Submitted',
      'appeal_intent_selected' => 'Appeal Intent Selected'
    }

    workflow do
      state :draft do
        event :submit, transition_to: :submitted
        event :appeal_intent_selected, transition_to: :appeal_intent_selected
      end
      state :submitted do
        event :submit, transition_to: :submitted
        event :appeal_intent_selected, transition_to: :appeal_intent_selected
      end
      state :appeal_intent_selected do
        event :submit, transition_to: :submitted
      end
    end
  end
end
