class Review::ASMPPInitial < Review::ASMPP
  workflow do
    state :screening do
      event :process, transition_to: :processing
      event :close, transition_to: :closed
    end

    state :processing do
      event :determination_made_sba_approved, transition_to: :sba_approved
      event :determination_made_decline_ineligible, transition_to: :sba_declined
      event :close, transition_to: :closed
    end

    state :sba_approved
    state :sba_declined
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
        assignment = ASMPPAssignment.create!(supervisor_id: user.id, reviewer_id: user.id, owner_id: user.id )
        review.assignments << assignment
        if application.bdmis_case_number.nil?
          review.screening_due_date = application.screening_due_date
        else
          review.workflow_state = Review::ASMPP::SBA_APPROVED
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