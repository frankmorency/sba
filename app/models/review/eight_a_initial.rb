class Review::EightAInitial < Review::EightA
  workflow do
    state :screening do
      event :process, transition_to: :processing
      event :send_15_day_letter, transition_to: :returned_with_15_day_letter
      event :send_deficiency_letter, transition_to: :returned_with_deficiency_letter
      event :close, transition_to: :closed
    end

    state :processing do
      event :determination_made_sba_approved, transition_to: :sba_approved
      event :determination_made_decline_ineligible, transition_to: :sba_declined
      event :user_submit_reconsideration, transition_to: :reconsideration
      event :close, transition_to: :closed
    end

    state :returned_with_15_day_letter do
      event :resubmit, transition_to: :screening
      event :close, transition_to: :closed
    end

    state :returned_with_deficiency_letter do
      event :resubmit, transition_to: :screening
    end

    state :determination_made do
    end

    state :sba_declined do
      event :start_pending_reconsideration_or_appeal_clock, transition_to: :pending_reconsideration_or_appeal, :if => proc { |review| review.determine_eligible_for_appeal == true }
      event :start_pending_reconsideration_or_appeal_clock, transition_to: :pending_reconsideration, :if => proc { |review| review.determine_eligible_for_appeal == false }
    end

    state :pending_reconsideration_or_appeal do
      event :user_submit_appeal, transition_to: :appeal
      event :user_submit_appeal_intent, transition_to: :appeal_intent
      event :user_submit_reconsideration, transition_to: :reconsideration
      event :closing, transition_to: :reconsideration
      event :close, transition_to: :closed
    end

    state :pending_reconsideration do
      event :user_submit_appeal, transition_to: :appeal
      event :user_submit_reconsideration, transition_to: :reconsideration
      event :closing, transition_to: :reconsideration
      event :close, transition_to: :closed
    end

    state :appeal do
    end

    state :appeal_intent do
      event :user_submit_appeal, transition_to: :appeal
      event :close, transition_to: :closed
      event :user_submit_reconsideration, transition_to: :reconsideration
    end

    state :reconsideration do
      event :user_submit_reconsideration, transition_to: :reconsideration
      event :process_for_reconsideration, transition_to: :processing
    end

    state :sba_approved do
    end

    state :closed do
      on_entry do
        remove_current_assignment
      end
    end

    # This is a hack to force workflow to update via the active record stack rather than
    # straight SQL used by the update_column method provide. This feild is then reset by
    # the observer at ElasticObserver.rb
    after_transition do
      self.update_attributes(workflow_dirty: true)
    end
  end

  def self.create_and_assign_review(user, application)
    return nil unless user.can_any_role?(:sba_analyst_8a_cods, :sba_supervisor_8a_cods, :sba_supervisor_8a_hq_aa, :sba_supervisor_8a_district_office, :sba_analyst_8a_district_office, :sba_supervisor_8a_hq_program, :sba_director_8a_district_office, :sba_deputy_director_8a_district_office)

    review = nil
    transaction do
      if application.certificate.current_review
        review = application.certificate.current_review
      else
        review = self.new(certificate_id: application.certificate.id, sba_application: application)
        assignment = EightAAssignment.create!(supervisor_id: user.id, reviewer_id: user.id, owner_id: user.id )
        review.assignments << assignment
        if application.bdmis_case_number.nil?
          review.screening_due_date = application.screening_due_date
        else
          review.workflow_state = Review::EightA::SBA_APPROVED
        end
        review.save!
        review.current_assignment_id = assignment.id
        review.save!
        assignment.update_column(:review_id, review.id)
      end
    end
    review
  end

  def close
    sba_application.review_closed!
    certificate.review_closed!
  end

end
