class Review::Master < Review
  # TODO: use global states...
  def self.create_and_assign_review(user, application, assignment_class, state)
    review = nil
    transaction do
      if application.certificate.current_review
        review = application.certificate.current_review
      else
        review = new(certificate_id: application.certificate.id, sba_application: application)
        assignment = assignment_class.create!(supervisor_id: user.id, reviewer_id: user.id, owner_id: user.id)
        review.assignments << assignment
        if application.bdmis_case_number.nil?
          review.screening_due_date = application.screening_due_date
        else
          review.workflow_state = state
        end
        review.save!
        review.current_assignment_id = assignment.id
        review.save!
        assignment.update_column(:review_id, review.id)
      end
    end
    review
  end

  def self.my_cases(user)
    where(workflow_state: "screening").joins(:assignments).where("assignments.reviewer_id = ?", user.id)
  end

  def self.my_cases_count(user)
    Assignment.joins(:review).where("reviews.current_assignment_id = assignments.id").where("(assignments.reviewer_id = :user_id AND assignments.owner_id != :user_id) OR (assignments.owner_id = :user_id AND assignments.reviewer_id != :user_id) OR (assignments.reviewer_id = :user_id AND assignments.owner_id = :user_id)", user_id: user.id).count
  end

  def self.status_label(review_state)
    STATE_LABELS[review_state]
  end

  def close
    sba_application.review_closed!
    certificate.review_closed!
  end

  def reassign_to(user)
    transaction do
      new_assignment = assignments.order(created_at: :desc).first.dup
      new_assignment.owner_id = user.id
      new_assignment.reviewer_id = user.id
      assignments << new_assignment
      save!
      sba_application.ignore_creator = true
      sba_application.update_attributes!(returned_reviewer: new_assignment.reviewer)
      self.current_assignment = new_assignment.reload
      save!
    end
  end

  def determine(req)
    self.determine_eligible = req.determine_eligible
    self.determine_eligible_for_appeal = req.determine_eligible_for_appeal
    if req.determine_eligible == "true"
      self.determination_made_sba_approved!
    else
      self.determination_made_decline_ineligible!
      self.start_pending_reconsideration_or_appeal_clock!
    end
    save!
    refer_to_new_owner_and_reviewer(req.individual)
  end

  def resubmit
    update_attribute :screening_due_date, 10.days.from_now.to_date
  end

  def due_date_days
    return nil unless due_date

    (due_date - Date.today).to_i
  end

  def due_date
    if processing?
      processing_due_date
    elsif screening?
      screening_due_date
    else
      nil
    end
  end

  def due_date_days_left
    return nil unless due_date_days

    if due_date_days >= 0
      "#{due_date_days} days left"
    elsif due_date_days < 0
      "#{due_date_days.abs} days overdue"
    end
  end
end
