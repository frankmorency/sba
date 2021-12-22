require 'sba_application/master_application'

class SbaApplication::EightAAnnualReview < SbaApplication::EightAMaster
  before_validation :set_kind, on: :create
  before_validation :set_review, on: :create

  # validates :review_for, presence: true

  def self.do_supervisor_unassigned_cases(user)
    eight_a.
    not_in_review.with_valid_cert.
    joins(:duty_stations).where('duty_stations.id' => user.duty_stations.map(&:id) ).
    order(created_at: :asc)
  end

  def self.send_reminder_email_on_anniversary(anniversary_date)
    program = "8(a)"
    vendor_admin_email = nil
    puts "Send second reminder email for applications in Draft"
    SbaApplication::EightAAnnualReview.where("review_for = ?", anniversary_date.to_date).each do |app|
      begin
        if app.workflow_state == "draft" # Send second email only if the application is in Draft
          org = app.organization
          vendor_admin_email = org.vendor_admin_user.try(:email)
          cc_email = app.certificate&.initial_app&.current_review&.case_owner&.email
          puts "sending email for second reminder, email: #{vendor_admin_email}, cc_email: #{cc_email}"
          AnnualReview8aReminderMailer.second_reminder(org, app.review_for, cc_email).deliver
          EmailNotificationHistory.create(organization_id: org.id, program: program, days: 30, email: vendor_admin_email, annual_review_sba_application_id: app.id)
        end
      rescue StandardError => e
        # Log error to Histroy table for reporting
        EmailNotificationHistory.create(organization_id: org.id, program: program, days: 30, error: e.message)
      end
    end

    puts "Send second reminder email for unclaimed firms"
    (1..8).each do |year|
      issue_date = year.year.ago
      puts "checking for issue_date: #{issue_date}"
      program = "8(a)"
      Certificate.eight_a.only_active.where("date(issue_date) = ?", issue_date.to_date).each do |cert|
        begin
          org = cert.organization
          raise("No org for certificate #{cert.id}") unless org
          if !org.default_user
            puts "certificate found, organization_id: #{org.id}, duns_number: #{org.duns_number}"
            cc_email = cert&.initial_app&.current_review&.case_owner&.email # CC emails to Case Owner
            # Do not send AR emails or setup ARs in the ninth year
            unless cert.in_ninth_year_of_participation?
              sam_email = org&.govt_bus_poc_email
              anniversary_date = Date.new(Date.today.year, cert.issue_date.month, cert.issue_date.day)
              puts "sending sam org email for second reminder, email: #{sam_email}, cc_email: #{cc_email}"
              AnnualReview8aReminderMailer.second_reminder(cert.organization, anniversary_date, cc_email).deliver
              EmailNotificationHistory.create(organization_id: org.id, program: program, days: 30, email: sam_email, annual_review_sba_application_id: nil, error: 'sam org email sent')
            end
          end
        rescue StandardError => e
          puts "!ERROR! - #{e}"
          #Log error to Histroy table for reporting
          EmailNotificationHistory.create(organization_id: org.id, program: program, days: 30, error: e.message)
        end
      end
    end
  end

  def in_ninth_year_of_participation?(on_date = nil)
    return false unless active?
    return false unless expiry_date
    on_date = Time.now if on_date.nil?
    return true if on_date > (expiry_date - 1.year) && on_date < expiry_date
    false
  end

  def annual?
    true
  end

  def app_overview_title
    "Annual Review"
  end

  def returned_with_letter?
    returned? && returned_with_letter_states.include?(current_review.workflow_state)
  end

  def returned_with_letter_states
    %w(returned_with_deficiency_letter early_graduation_recommended
       termination_recommended voluntary_withdrawal_recommended)
  end

  def submit
    if program.try(:name) == "eight_a" && Feature.active?(:notifications)
      send_application_submited_notification(self)
    end

    submit_without_certificate
    current_review.resubmit! if returned_with_letter?
    certificate
  end

  def submit_hook
    # 8(a) Annual Review Screening due - 15 days from time of submissison
    self.update_column(:screening_due_date, 15.days.from_now.to_date ) unless returned_with_letter?

    unless certificate.servicing_bos.nil?
      owner = certificate.servicing_bos

      Review::EightAAnnualReview.create_and_assign_review(owner, self)
      ApplicationController.helpers.log_activity_application_event('owner_changed', self.id, owner.id, owner.id)
      if Feature.active?(:notifications)
        if self.is_really_a_review?
          send_notification_to_refered("8(a)", master_application_type(self), "assigned", owner.id, nil, owner.email, self.organization.name, self.case_number)
        else
          send_notification_to_refered("8(a)", master_application_type(self), "assigned", owner.id, self.id, owner.email, self.organization.name)
        end
      end
    end
  end

  def fifteen_day_return!(the_return, current_user)
    raise "15 day returns can only be made on initial applications, not annual reviews"
  end

  def deficiency_letter_return!(the_return, current_user)
    transaction do
      current_review.send_deficiency_letter!
      persist_workflow_state('returned')
      progress['current'] = nil
      self.application_submitted_at = nil
      self.screening_due_date = nil
      current_review.update_attributes letter_due_date: 10.days.from_now.to_date, screening_due_date: nil
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
      save!
      current_review.destroy!
    end

    if Feature.active?(:notifications)
      send_notification_and_email_of_returned_application(self, the_return, current_user, false)
    end
  end

  def last_review_date
    if certificate.annual_review_applications.empty?
      certificate.issue_date.to_date
    else
      certificate.annual_review_applications.first.review_for
    end
  end

  def valid_application?
    return true unless no_more_reviews?
  end

  def no_more_reviews?
    certificate.expiry_date.to_time.to_i < Date.today.to_time.to_i
  end

  # If this is december and last_review occured in January.
  def is_december_reviewed_in_january?(expected_review)
    return false unless review_next_year?(expected_review)
    return false unless last_review_date.month == 1
    return false unless Date.today.month == 12
    true
  end

  def review_next_year?(expected_review)
    last_review_date.year == Date.today.year + 1
  end

  def reviewed_this_year?(expected_review)
    last_review_date.year == Date.today.year
  end

  # in the next month
  def next_review_date
    expected_review = last_review_date
    if is_december_reviewed_in_january?(expected_review)
      expected_review = expected_review.change(year: Date.today.year + 1)
    elsif reviewed_this_year?(expected_review)
      expected_review = expected_review.change(year: Date.today.year + 1)
    else
      expected_review = expected_review.change(year: Date.today.year)
    end
    # On launch date, we are going to allow creation of Annual Reviews dues in last 1 month
    if expected_review <= 1.month.from_now.to_date && expected_review >= 1.month.ago.to_date
      expected_review
    else
      nil
    end
  end

  private

  def set_kind
    self.kind = ANNUAL_REVIEW
  end

  def set_review
    if no_more_reviews?
      raise "No more annual reviews available for for this certificate"
    elsif next_review_date.nil?
      self.errors.add(:review_number, "is not due yet")
    else
      years_of_program_eligibility = certificate.covid_issue_date? ? 10 : 9
      self.review_for = next_review_date
      self.review_number = years_of_program_eligibility - (certificate.expiry_date.to_date.year - Date.today.year).to_i
      self.review_number = 1 if review_number < 1
      self.review_number = 9 if review_number > 9
    end
  end
end
