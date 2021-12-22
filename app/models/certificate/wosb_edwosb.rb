class Certificate::WosbEdwosb < Certificate
  after_create  :start

  workflow do
    state :active do
      event :cancel_review, transition_to: :active
      event :assign, transition_to: :active
      event :propose_eligible, transition_to: :active
      event :propose_ineligible, transition_to: :active
      event :determination_made_sba_approved, transition_to: :active

      event :determination_made_decline_ineligible, transition_to: :ineligible
      event :deactivate, transition_to: :inactive
      event :expire, transition_to: :expired
    end

    state :inactive do
      event :deactivate, transition_to: :inactive
      event :activate, transition_to: :active
    end

    state :ineligible do
    end

    state :pending do
    end

    state :expired do
    end

    # This is a hack to force workflow to update via the active record stack rather than 
    # straight SQL used by the update_column method provide. This feild is then reset by
    # the observer at ElasticObserver.rb
    after_transition do
      self.update_attributes(workflow_dirty: true)
    end
  end

  def renewable?(user)
    # return false unless user.can?(:ensure_vendor, user)

    # return false if certificate_type.annual_review_questionnaire.sba_applications.in_an_open_state.where(organization: user.one_and_only_org, kind: SbaApplication::ANNUAL_REVIEW).count > 0

    # if expired?
    #   return false if most_recent_certificate.active? || most_recent_certificate != self
    # end

    # expiry_date && Date.today >= expiry_date.to_date - certificate_type.renewal_notification_period_in_days
    return false
  end
end
