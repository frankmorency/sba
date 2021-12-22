class DataDictionary3 < ActiveRecord::Migration
  def change
    if %w(dev development qa test build docker).include? Rails.env
      # access_requests
      set_table_comment :access_requests, "Tracks access requests by contracting officers to review a specific organization"
      set_column_comment :access_requests, :id, "Primary Key (serial) for record uniqueness."
      set_column_comment :access_requests, :user_id, "Foreign Key to the Users table. The CO making the request."
      set_column_comment :access_requests, :organization_id, "Foreign Key to the Organizations table. The org they're requesting access to"
      set_column_comment :access_requests, :solicitation_number, "The solicitation number - ask mary"
      set_column_comment :access_requests, :solicitation_naics, "The solicitation naics - ask mary"
      set_column_comment :access_requests, :procurement_type, "The procurement type - ask mary"
      set_column_comment :access_requests, :status, "The current status of the Access Request. Possible values include Requested, Accepted, Rejected, Revoked or Expired."
      set_column_comment :access_requests, :accepted_on, "The date the request was accepted"
      set_column_comment :access_requests, :request_expires_on, "The date when the request expires."
      set_column_comment :access_requests, :access_expires_on, "The date the access itself expires"
      set_column_comment :access_requests, :type, "The class that this request belongs to."
      set_column_comment :access_requests, :role_id, "Foreign Key to the Roles table."

      # agency_requirements
      set_column_comment :agency_requirements, :title, "Name of the company"
      set_column_comment :agency_requirements, :description, "Description of the work to be performed."
      set_column_comment :agency_requirements, :received_on, "When the requirement was received by the SBA."
      set_column_comment :agency_requirements, :estimated_contract_value, "An estimate of the amount to be awarded."
      set_column_comment :agency_requirements, :contract_value, "The actual amount that was awarded."
      set_column_comment :agency_requirements, :offer_solicitation_number, ""
      set_column_comment :agency_requirements, :offer_value, ""
      set_column_comment :agency_requirements, :contract_number, ""
      set_column_comment :agency_requirements, :agency_comments, "Comments about the agency"
      set_column_comment :agency_requirements, :contract_comments, "Comments about the contract"
      set_column_comment :agency_requirements, :comments, "Additional Comments"
      set_column_comment :agency_requirements, :contract_awarded, "Indicates if contract was awarded."
      set_column_comment :agency_requirements, :case_number, "The case number on the e8a database"
      set_column_comment :agency_requirements, :e8a_created_at, "When it was created in the e8a database"
      set_column_comment :agency_requirements, :e8a_deleted_at, "When it was deleted in the e8a database"

      # annual_reports
      set_column_comment :annual_reports, :status, "Current status of the annual report. Possible values include Approved, Declined or Returned"

      # applicable_questions
      set_column_comment :applicable_questions, :positive_response, "Indicates which response from the user that is considered successful"
      set_column_comment :applicable_questions, :lookup, "Hash used to lookup NAICS code"

      # assessments
      set_table_comment :assessments, "The assessments table is where analysts store their notes and statuses on specific questions and sections of a questionnaire"
      set_column_comment :assessments, :review_id, "Foreign Key to the Reviews table."
      set_column_comment :assessments, :note_id, "Foreign Key to the Notes table."
      set_column_comment :assessments, :assessed_by_id, "Foreign Key to the Users table. The assessor - analyst - a user"
      set_column_comment :assessments, :the_assessed_type, "The thing we're assessing."
      set_column_comment :assessments, :the_assessed_id, "The id of that thing we're assessing."
      set_column_comment :assessments, :status, "Current status of the Assessment. Possible values include 'Confirmed', 'Not reviewed', 'Information missing', 'Makes vendor ineligible' or Needs 'further review'."
      set_column_comment :assessments, :new_reviewer_id, "Foreign Key to the Users table. Stores the id of the new current reviewer"
      set_column_comment :assessments, :determination_decision, "Stores the current determination decision"

      # av_status_history
      set_column_comment :av_status_history, :start_time, "When the scan started."
      set_column_comment :av_status_history, :end_time, "When the scan ended."
      set_column_comment :av_status_history, :total_documents, "The number of documents being scanned."
      set_column_comment :av_status_history, :total_errors, "The number of errors that occurred during the scan."
      set_column_comment :av_status_history, :error_message, "The error message if applicable"

      # bdmis_migrations
      set_column_comment :bdmis_migrations, :id, "Primary Key (serial) for record uniqueness."
      set_column_comment :bdmis_migrations, :sba_application_id, "Foreign Key to the SBA Applications table."
      set_column_comment :bdmis_migrations, :error_messages, ""
      set_column_comment :bdmis_migrations, :approval_date, ""
      set_column_comment :bdmis_migrations, :case_number, ""
      set_column_comment :bdmis_migrations, :case_url, ""
      set_column_comment :bdmis_migrations, :certification, ""
      set_column_comment :bdmis_migrations, :company_name, ""
      set_column_comment :bdmis_migrations, :decline_date, ""
      set_column_comment :bdmis_migrations, :ein, ""
      set_column_comment :bdmis_migrations, :next_review, ""
      set_column_comment :bdmis_migrations, :office, ""
      set_column_comment :bdmis_migrations, :page, ""
      set_column_comment :bdmis_migrations, :status, ""
      set_column_comment :bdmis_migrations, :submitted_on_date, ""
      set_column_comment :bdmis_migrations, :exit_date, ""
      set_column_comment :bdmis_migrations, :approved_date, ""
      set_column_comment :bdmis_migrations, :office_code, ""
      set_column_comment :bdmis_migrations, :office_name, ""
      set_column_comment :bdmis_migrations, :district_code, ""
      set_column_comment :bdmis_migrations, :district_name, ""
      set_column_comment :bdmis_migrations, :duns, ""
      set_column_comment :bdmis_migrations, :hashed_duns, ""

      # certificate_types
      set_column_comment :certificate_types, :renewal_notification_period_in_days, "How many days in advance of their renewal date that the vendor gets a notification."
      set_column_comment :certificate_types, :annual_report_period_in_days, "Number of days between annual reports. Spoiler alert...365"
      set_column_comment :certificate_types, :type, "Sub-class of certificate: WOSB, MPP, etc."
      set_column_comment :certificate_types, :duration_in_days, "How long the cert lasts"
      set_column_comment :certificate_types, :wait_period_in_days, "How long the vendor needs to wait before recertifying"
      set_column_comment :certificate_types, :renewal_period_in_days, "How long the vendor needs to wait to renew"

      # certificates
      set_column_comment :certificates, :expiry_date, "When the certificate expires"
      set_column_comment :certificates, :issue_date, "When the certificate was created."
      set_column_comment :certificates, :workflow_dirty, "Attribute used to make the workflow gem work with Elasticsearch"
      set_column_comment :certificates, :original_certificate_id, "THIS COLUMN IS NEEDED IN THE INTERIM TO TIE ANNUAL RENEWAL (ANNUAL REPORT) CERTS TO THE ORIGINAL CERTIFICATE THAT WAS CREATED FOR THEM"
      set_column_comment :certificates, :next_annual_report_date, "When the next MPP annual report is due"

      # contributors
      set_column_comment :contributors, :position, "The numerical order in which the contributor request was made"
      set_column_comment :contributors, :section_name_type, "The name of the section that is the template for this contributor's questionnaire"
      set_column_comment :contributors, :expires_at, "When the email request sent to the contributor expires."

      # cron_job_histories
      set_column_comment :cron_job_histories, :type, "The command used to run the cron job."
      set_column_comment :cron_job_histories, :start_time, "When the cron job started."
      set_column_comment :cron_job_histories, :end_time, "When the cron job ended."

      # current_questionnaires
      set_table_comment :current_questionnaires, ""
      set_column_comment :current_questionnaires, :kind, "Indicates if the currently active questionnaire is an initial or annual review."

      # determinations
      set_column_comment :determinations, :decision, "The outcome of the determination. Possible values include 'SBA Declined' or 'SBA Approved'"
      set_column_comment :determinations, :decider_id, "Foreign Key to the Users table. The person making the determination."
      set_column_comment :determinations, :eligible, "There are multiple determination outcomes, all of which are still considered 'eligible'. This flag makes it more obvious which are which"

      # duty_stations
      set_column_comment :duty_stations, :facility_code, "9 digit code used to identify a duty station"

      # email_notification_histories
      set_table_comment :email_notification_histories, "Log of Email Notifications sent to a vendor"
      set_column_comment :email_notification_histories, :program, "The program for which the email notification was sent."
      set_column_comment :email_notification_histories, :days, "Number of days until certificate expiration."
      set_column_comment :email_notification_histories, :email, "The email of the recipient."

      # event_logs
      set_table_comment :event_logs, "Generic event log"

      # expiration_dates
      set_table_comment :expiration_dates, "Used to change expiration dates for access requests"
      set_column_comment :expiration_dates, :type, "Not used"
      set_column_comment :expiration_dates, :model, "Name of the other table whose expiration dates we're overriding"
      set_column_comment :expiration_dates, :field, "Name of the specific field in the other table"
      set_column_comment :expiration_dates, :days_from_now, "The number of days until this expiration"

      # groups
      set_table_comment :groups, "Used to filter the types of applications sba staff can see - the only types of groups discussed so far are regional offices for the 8a program."

      # help_pages
      set_table_comment :help_pages, "Used to display FAQ-style content (no longer used)"
      set_column_comment :help_pages, :title, "Content for title section"
      set_column_comment :help_pages, :left_panel, "Content for left panel"
      set_column_comment :help_pages, :right_panel, "Content for right panel"

      # permission_requests
      set_table_comment :permission_requests, "Mapping between a user and their access request"

      # question_presentations
      set_column_comment :question_presentations, :repeater_label, "Text to be displayed for repeating questions - see US1418"
      set_column_comment :question_presentations, :minimum, "Minimum number of answers for the repeating question type"
      set_column_comment :question_presentations, :maximum, "Maximum number of answers for the repeating question type "

      # questionnaire_histories
      set_table_comment :questionnaire_histories, "Used for questionnaire versioning"
      set_column_comment :questionnaire_histories, :kind, "The type of questionnaire"
      set_column_comment :questionnaire_histories, :version, "Version of the questionnaire"

      # questionnaires
      set_column_comment :questionnaires, :prerequisite_order, ""
      set_column_comment :questionnaires, :vendor_can_start, "Indicates if a vendor can start the questionnaire"
      set_column_comment :questionnaires, :analyst_can_start, "Indicates if an analyst can start the questionnaire"
      set_column_comment :questionnaires, :scheduler_can_start, ""

      # questions
      set_column_comment :questions, :prepopulate, "Indicates if a questions can be prepopulated with the users' previous answer"

      # reviews
      set_table_comment :reviews, "Used to track analyst reviews on sba applications and certifications"
      set_column_comment :reviews, :type, "sub class of review since we'll have different types of reviews which may eventually have their own workflows"
      set_column_comment :reviews, :case_number, "autogenerated unique identifier analysts can use to refer to a review, in the format of MZ12312341 (two letters followed by timestamp number)"
      set_column_comment :reviews, :sba_application_id, "Foreign Key to the SBA Applications table."
      set_column_comment :reviews, :certificate_id, "Foreign Key to the Certificates table."
      set_column_comment :reviews, :current_assignment_id, "Refers to the current owner / reviewer and surpervisor (analysts)"
      set_column_comment :reviews, :workflow_state, "Used by the workflow gem to track the current state of the review"
      set_column_comment :reviews, :determination_id, "Foreign Key to the Determinations table."
      set_column_comment :reviews, :recommend_eligible, "Boolean indicating if the review has been recommended to be eligible"
      set_column_comment :reviews, :recommend_eligible_for_appeal, "Boolean indicating if the review has been recommended to be eligible for appeal"
      set_column_comment :reviews, :determine_eligible, "Boolean indicating if the review has been determined to be eligible"
      set_column_comment :reviews, :determine_eligible_for_appeal, "Boolean indicating if the review has been determined to be eligible for appeal"
      set_column_comment :reviews, :workflow_dirty, "Attribute used to make the workflow gem work with Elasticsearch"
      set_column_comment :reviews, :processing_due_date, "When a review is due after application enters processing state"
      set_column_comment :reviews, :letter_due_date, "Due date of the 15 day letter"

      # sba_applications
      set_column_comment :sba_applications, :master_application_id, "The id of the master application this sub-application is associated with"
      set_column_comment :sba_applications, :position, "The order in which the application was created."
      set_column_comment :sba_applications, :prerequisite_order, ""
      set_column_comment :sba_applications, :workflow_dirty, "Attribute used to make the workflow gem work with Elasticsearch"
      set_column_comment :sba_applications, :kind, "The type of SBA Application. Possible values include initial, annual_review, adhoc, reconsideration, info_request or entity_owned_initial"
      set_column_comment :sba_applications, :unanswered_adhoc_reviews, "The count of unanswered adhoc reviews"
      set_column_comment :sba_applications, :adhoc_question_title, "The question title of the adhoc questionnaire"
      set_column_comment :sba_applications, :adhoc_question_details, "The question detail of the adhoc questionnaire"
      set_column_comment :sba_applications, :returned_reviewer_id, ""
      set_column_comment :sba_applications, :original_certificate_id, "HIS COLUMN IS NEEDED IN THE INTERIM TO TIE ANNUAL RENEWAL (ANNUAL REPORT) CERTS TO THE ORIGINAL CERTIFICATE THAT WAS CREATED FOR THEM"
      set_column_comment :sba_applications, :renewal, "Indicates if application is a renewals of an initial application"
      set_column_comment :sba_applications, :workflow_state, "Used by the workflow gem to track the current state of the application"
      set_column_comment :sba_applications, :version_number, "Sequential version to be displayed in the UI"
      set_column_comment :sba_applications, :current_sba_application_id, "The id of the master application this version is associated with"
      set_column_comment :sba_applications, :is_current, "Boolean indicating if this application is the current one."
      set_column_comment :sba_applications, :sam_snapshot, "JSON with most current SAM data for the organization associated with this application"
      set_column_comment :sba_applications, :certificate_id, "Foreign Key to the Certificate table."

      # section_rules
      set_column_comment :section_rules, :is_multi_path_template, "Determines if this rule contain a multi-path question that enables / disables other sections"
      set_column_comment :section_rules, :terminal_section_id, "The next section to go to after the potential sections that are enabled by the multi-path rule"
      set_column_comment :section_rules, :generated_from_id, "For dynamically created section rules (from multi path questions), this points to the original section_rule that created the section"

      # sections
      set_column_comment :sections, :review_position, "Added to make it easier to present the question review page with properly ordered sections and questions to analysts"
      set_column_comment :sections, :sub_sections_completed, "Used to determine whether to show a green checkmark in the questionnaire side nav"
      set_column_comment :sections, :sub_sections_applicable, "Used to determine whether to gray out the section in the questionnaire side nav"
      set_column_comment :sections, :defer_applicability_for_id, "Multi-path sections need to be skipped when going to the review section, this is how we know what they are"

      # users
      set_column_comment :users, :current_sign_in_at, "When the user currently signed in."
      set_column_comment :users, :last_sign_in_at, "The last time the user signed in"
      set_column_comment :users, :provider, "authentication provider"
      set_column_comment :users, :uid, "id of the authentication provider"
      set_column_comment :users, :max_user_classification, "MAX.gov clasification ( federal or contractor )"
      set_column_comment :users, :max_agency, "User's agency within MAX.gov ( Small Buisness Adminstration )"
      set_column_comment :users, :max_org_tag, "User's agency tag name (abreviation ex SBA) in MAX.gov"
      set_column_comment :users, :max_group_list, "User's groups within MAX.gov"
      set_column_comment :users, :max_id, "User's MAX.gov ID which is *-> Max primary key <-*"
      set_column_comment :users, :max_first_name, "User's first name in MAX.gov"
      set_column_comment :users, :max_security_level_list, "User's security level in MAX.gov"
      set_column_comment :users, :max_last_name, "User's last name in MAX.gov"
      set_column_comment :users, :max_email, "User's email in MAX.gov"
      set_column_comment :users, :max_bureau, "User's bureau within an organization saved in MAX.gov"
      set_column_comment :users, :uuid, "A better unique id for the user"
    end
  end
end
