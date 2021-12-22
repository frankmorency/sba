class Review::OutOfCycle < Review
  workflow do
    state :processing do
      event :retain_firm, transition_to: :retained
      event :recommended_early_graduation, transition_to: :early_graduation_recommended
      event :recommended_termination, transition_to: :termination_recommended
      event :recommended_voluntary_withdrawal, transition_to: :voluntary_withdrawal_recommended
      event :finalize_voluntary_withdrawal, transition_to: :voluntary_withdrawn
      event :finalize_early_graduation, transition_to: :early_graduated
      event :finalize_termination, transition_to: :terminated
      event :cancel, transition_to: :cancelled
    end

    state :early_graduation_recommended do
      event :recommended_early_graduation, transition_to: :early_graduation_recommended
      event :recommended_termination, transition_to: :termination_recommended
      event :recommended_voluntary_withdrawal, transition_to: :voluntary_withdrawal_recommended
      event :finalize_voluntary_withdrawal, transition_to: :voluntary_withdrawn
      event :finalize_early_graduation, transition_to: :early_graduated
      event :finalize_termination, transition_to: :terminated
      event :cancel, transition_to: :cancelled
    end

    state :termination_recommended do
      event :recommended_early_graduation, transition_to: :early_graduation_recommended
      event :recommended_termination, transition_to: :termination_recommended
      event :recommended_voluntary_withdrawal, transition_to: :voluntary_withdrawal_recommended
      event :finalize_voluntary_withdrawal, transition_to: :voluntary_withdrawn
      event :finalize_early_graduation, transition_to: :early_graduated
      event :finalize_termination, transition_to: :terminated
      event :cancel, transition_to: :cancelled
    end

    state :voluntary_withdrawal_recommended do
      event :recommended_early_graduation, transition_to: :early_graduation_recommended
      event :recommended_termination, transition_to: :termination_recommended
      event :recommended_voluntary_withdrawal, transition_to: :voluntary_withdrawal_recommended
      event :finalize_voluntary_withdrawal, transition_to: :voluntary_withdrawn
      event :finalize_early_graduation, transition_to: :early_graduated
      event :finalize_termination, transition_to: :terminated
      event :cancel, transition_to: :cancelled
    end

    state :voluntary_withdrawn do
      on_entry do
        remove_current_assignment
      end
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

    state :cancelled
  end

  # APPLICATION METHODS

  delegate  :organization, to: :certificate

  def self.not_cancelled
    where('workflow_state != ?', :cancelled)
  end

  def appeal_intent?
    false
  end

  def is_really_a_review?
    true
  end

  def label
    'Adverse Action'
  end

  def display_messages?
    false
  end

  def awaiting_reconsideration_submission?
    false
  end

  def info_request?
    false
  end

  def is_annual?
    false
  end

  def is_initial?
    false
  end

  def has_active_certificate?
    false
  end

  def duty_station_name
    nil
  end

  def servicing_bos_name
    nil
  end

  def migrated_from_bdmis?
    false
  end

  def show_funbar?
    true
  end

  def first_section
    nil
  end

  def display_activity_log?
    false
  end

  def display_documents?
    true
  end

  def display_notes?(arg)
    true
  end

  def tags
    ['Adverse Action', 'BOS', 'Supervisor'].map{ |name| Tag.find_by_name(name)}
  end

  def masthead_title
    "8(a) Adverse Action Review"
  end

  def masthead_subtitle
    nil
  end

  def display_kind
    "Adverse Action"
  end

  def kind
    'adverse_action'
  end

  def current_review
    self
  end

  def returned_with_letter?
    false
  end

  def submitted_reconsideration?
    false
  end

  def due_date
    Date.today
  end

  def updates_needed?
    false
  end

  def due_date_days_left
    0
  end

  def get_current_analyst_reviewer
    assignments.first.reviewer
  end

  def all_documents(user_id_value=nil, is_active_value=true, is_analyst_value=false)
    documents = []
    documents << user_id_value.nil? ? self.documents.where(is_active: is_active_value).where(is_analyst: is_analyst_value) : self.documents.where(is_active: is_active_value).where(is_analyst: is_analyst_value).where(user_id: user_id_value)
  end

  # REAL METHODS
  #

  def self.get(case_number)
    Review::AdverseAction.find_by(case_number: case_number) ||
        Review::IntentTo.find_by(case_number: case_number)
  end

  def self.assigned_to(user)
    Review.joins(:assignments).where(type: %w(Review::AdverseAction Review::IntentTo)).where('((? IN (SELECT owner_id from (select * FROM sbaone.assignments WHERE review_id = reviews.id order by created_at desc LIMIT 1) as rev)) OR (? IN (SELECT reviewer_id from (select * FROM sbaone.assignments WHERE review_id = reviews.id order by created_at desc LIMIT 1) as rev)))', user.id, user.id)
  end

  def self.create_and_assign_review(user, organization)
    return nil unless user.is_servicing_bos?(organization)

    # limited to 8(a) certs...
    certificate = organization.certificates.includes(:certificate_type).where('certificate_types.name' => 'eight_a').order(created_at: :desc).first

    return nil unless certificate

    review = nil
    transaction do
      review = self.new(certificate_id: certificate.id)
      assignment = Assignment.create!(supervisor_id: user.id, reviewer_id: user.id, owner_id: user.id )
      review.assignments << assignment
      review.screening_due_date = Date.today #WHEN?

      review.save!
      review.current_assignment_id = assignment.id
      review.save!
      assignment.update_column(:review_id, review.id)
    end
    review
  end

  def has_reconsideration_sections?
    false
  end

  def is_out_of_cycle?
    true
  end

  def cancel

  end

  def close
    certificate.review_closed!
  end
end
