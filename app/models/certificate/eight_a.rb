class Certificate::EightA < Certificate
  include CertificateWorkflow
  include SbaApplicationHelper

  def self.create_annual_reviews!(days_offset = 30.days, exclude_duns = [])
    # Find firms with 1 to 8 year Anniversaries on their Certificate expiry_date
    review_number_is_not_due_yet = false
    (1..8).each do |year|
      expiry_date = year.year.ago + days_offset
      puts "checking for expiry_date: #{expiry_date}"
      program = "8(a)"
      Certificate.eight_a
      .only_active
      .where("date(expiry_date) > ?", expiry_date.to_date)
      .where("to_char(expiry_date, 'MM/DD') = to_char(current_date + interval ?, 'MM/DD')", "'#{days_offset/60/60/24} days'")
      .each do |cert|
        begin
          if  !review_number_is_not_due_yet
            org = cert.organization
            raise("No org for certificate #{cert.id}") unless org
            puts "certificate found, DUNS: #{org.duns_number}, organization_id: #{org.id}"
            cc_email = cert&.initial_app&.current_review&.case_owner&.email # CC emails to Case Owner
            if exclude_duns.include?(org.duns_number)
              puts "excluded duns_number found, duns_number: #{org.duns_number}, organization_id: #{org.id}"
              EmailNotificationHistory.create(organization_id: org.id, program: program, days: 60, error: 'excluded duns number')
              next
            end

            # Do not create Annual Reviews for certificates with a Finalized Adverse Action
            if cert&.finalized?
              puts "excluded duns_number found, duns_number: #{org.duns_number}, organization_id: #{org.id}"
              EmailNotificationHistory.create(organization_id: org.id, program: program, days: 60, error: 'excluded finalized adverse action')
              next
            end

            # Do not send AR emails or setup ARs in the ninth year
            if org.default_user
              default_user_email = org.default_user.try(:email)
              puts "creating annual review, email: #{default_user_email}, cc_email: #{cc_email}"
              app = cert.organization.create_eight_a_annual_review!
              ApplicationController.helpers.log_activity_application_event('created_system', app.id)

              AnnualReview8aReminderMailer.first_reminder(cert.organization, app.review_for, cc_email).deliver if !default_user_email.nil?
              EmailNotificationHistory.create(organization_id: org.id, program: program, days: 60, email: default_user_email, annual_review_sba_application_id: app.id)
            else
              sam_email = org&.govt_bus_poc_email
              anniversary_date = Date.new(Date.today.year, cert.issue_date.month, cert.issue_date.day)
              puts "sending sam org email, email: #{default_user_email}, cc_email: #{cc_email}"
              AnnualReview8aReminderMailer.first_reminder(cert.organization, anniversary_date, cc_email).deliver if !default_user_email.nil?
              EmailNotificationHistory.create(organization_id: org.id, program: program, days: 60, email: sam_email, annual_review_sba_application_id: nil, error: 'sam org email sent')
            end
          end
        rescue StandardError => e
          puts "!ERROR! - #{e}"
          review_number_is_not_due_yet = e.message == "Validation failed: Review number is not due yet"
          #Log error to Histroy table for reporting
          EmailNotificationHistory.create(organization_id: org.id, program: program, days: 60, error: e.message)
          #Send exception notification alert
          message =  "Problem encountered creating Annual Review: #{e.message}"
          ExceptionNotifier.notify_exception(e, data: { message: message }) if Rails.env.production?
        end
      end
    end
  end

  # check dates for initial apps approved to qualify for COVID benefits
  def covid_issue_date?
    issue_date.between?('2011-3-13'.to_date, '2020-9-9'.to_date)
  end

  def title
    if doc_upload?
      "8(a) Document Upload"
    else
      super
    end
  end

  def decision
    self.ineligible? ? 'Declined' : ''
  end

  def renewable?(user)
    false
  end
end
