module MasterApplicationWorkflow
  extend ActiveSupport::Concern
  include NotificationsHelper

  included do
    WORKFLOW_STATE_NAMES = {
        'draft' => 'Draft',
        'submitted' => 'Submitted',
        'under_review' => 'Under Review',
        'complete' => 'Complete',
        'inactive' => 'Inactive',
        'returned' => 'Returned',
    }

    workflow do
      state :draft do
        event :submit, transition_to: :submitted
        event :full_return, transition_to: :returned
        event :review_closed, transition_to: :complete

        event :finalize_voluntary_withdrawal, transition_to: :complete
        event :finalize_early_graduation, transition_to: :complete
        event :finalize_termination, transition_to: :complete
      end
      state :submitted do
        event :reopen, transition_to: :draft
        event :assign, transition_to: :under_review

        event :determination_made_decline_ineligible, transition_to: :complete
        event :determination_made_sba_approved, transition_to: :complete

        event :full_return, transition_to: :returned

        event :review_closed, transition_to: :complete

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

        event :review_closed, transition_to: :complete
      end

      state :complete do
        event :review_closed, transition_to: :complete
      end

      state :inactive do
      end

      state :returned do
        event :submit, transition_to: :submitted
        event :review_closed, transition_to: :complete
        event :finalize_voluntary_withdrawal, transition_to: :complete
        event :finalize_early_graduation, transition_to: :complete
        event :finalize_termination, transition_to: :complete
      end

      # This is a hack to force workflow to update via the active record stack rather than
      # straight SQL used by the update_column method provide. This field is then reset by
      # the observer at ElasticObserver.rb
      after_transition do
        self.update_attributes(workflow_dirty: true)
      end
    end

    def fifteen_day_return!(the_return, current_user)
      transaction do
        current_review.send_15_day_letter!
        persist_workflow_state('returned')
        progress['current'] = nil
        self.application_submitted_at = nil
        current_review.update_attributes letter_due_date: 15.days.from_now.to_date, screening_due_date: nil
        save!

        if Feature.active?(:notifications)
          send_notification_and_email_of_returned_application(self, the_return, current_user, true)
        end
      end
    end

    def full_return!(the_return, current_user)
      full_return(the_return, current_user)
    end

    def full_return(the_return, current_user)
      transaction do
        persist_workflow_state('returned')
        progress['current'] = nil
        self.application_submitted_at = nil
        self.screening_due_date = nil
        duty_stations.clear # Remove Duty Stations on full_return. They will be set again by CODS when the user resubmits!
        save!
        current_review.destroy!
        certificate.destroy!
        update_attribute :certificate_id, nil
      end

      if Feature.active?(:notifications)
        send_notification_and_email_of_returned_application(self, the_return, current_user, true)
      end
    end
  end
end
