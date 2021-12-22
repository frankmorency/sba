class DataDictionary < ActiveRecord::Migration
  def change
    # access_requests
    # "id","user_id","organization_id","solicitation_number","solicitation_naics","procurement_type","status","accepted_on","request_expires_on","access_expires_on","deleted_at","created_at","updated_at","type","role_id","roles_map"
    set_table_comment :access_requests, "A table comment"
    set_column_comment :access_requests, :id, "Primary Key (serial) for record uniqueness."
    set_column_comment :access_requests, :roles_map, "this is the user hash where the roles will be saved"

    # annual_reports
    # "id","certificate_id","sba_application_id","status","reviewer_id","created_at","updated_at"
    set_table_comment :annual_reports, "A table comment"
    set_column_comment :annual_reports, :id, "Primary Key (serial) for record uniqueness."
    set_column_comment :annual_reports, :certificate_id, "TBD"
    set_column_comment :annual_reports, :sba_application_id, "TBD"
    set_column_comment :annual_reports, :status, "TBD"
    set_column_comment :annual_reports, :reviewer_id, "TBD"

    # anonymous_users
    set_table_comment :anonymous_users, "The anonymous_user stores a record for every user that take the am-i-eligible survey."

    # answer_documents
    set_table_comment :answer_documents, "The answer_documents table are documents that are added by answer for further information."

    # answers
    # "id","type","owner_id","owner_type","sba_application_id","question_id","evaluated_response","response","comment","deleted_at","created_at","updated_at","value","details","answered_for_id","answered_for_type"
    set_table_comment :answers, "The answers table tracks the responses provided by a user."
    set_column_comment :answers, :answered_for_id, "	Indicates who or for whom the answer was entered."
    set_column_comment :answers, :answered_for_type, "The type of table the ID is associated with. "
    set_column_comment :answers, :comment, "Field for users to add additional notes to their answers."
    set_column_comment :answers, :created_at, "Date and time the record was created. "
    set_column_comment :answers, :deleted_at, "Date and time the record was soft deleted."
    set_column_comment :answers, :details, "Detailed response for the answer. Json type to hold complex responses."
    set_column_comment :answers, :evaluated_response, "Response which determines which answer is correct."
    set_column_comment :answers, :id, "Primary Key (serial) for record uniqueness. "
    set_column_comment :answers, :owner_id, "Composite key (owner_id and owner_type) indicates either the Users or the Anonymous Users table. "
    set_column_comment :answers, :owner_type, "User identification role."
    set_column_comment :answers, :question_id, "Foreign Key to the Questions table."
    set_column_comment :answers, :response, "Answer provided by the user."
    set_column_comment :answers, :sba_application_id, "Foreign Key to the SBA Applications table."
    set_column_comment :answers, :type, "Type of application (WOSB, EDWOSB, 8(a) etc.). (might be changed to a text column)."
    set_column_comment :answers, :updated_at, "Date and time the record was last updated. "
    set_column_comment :answers, :value, "	Aggregated response for the answer. With introduction of Form 413 questions, this has been changed to a json type to handle complex responses with more that one value."

    # applicable_questions
    set_table_comment :applicable_questions, "The applicable_questions table is a list of questions asked to become certified."

    # application_status_histories
    set_table_comment :application_status_histories, "The application_status_histories stores the history of each certification."

    # application_status_types
    set_table_comment :application_status_types, "The application_status_types stores the different status an certification can have."

    # assessments
    # "id","review_id","note_id","assessed_by_id","the_assessed_type","the_assessed_id","status","deleted_at","created_at","updated_at","determination_decision","new_reviewer_id"
    set_table_comment :assessments, "A table comment"
    set_column_comment :assessments, :id, "Primary Key (serial) for record uniqueness."

    # assignments
    # "id","review_id","supervisor_id","owner_id","reviewer_id","deleted_at","created_at","updated_at"
    set_table_comment :assignments, "A table comment"
    set_column_comment :assignments, :id, "Primary Key (serial) for record uniqueness."

    # av_status_history
    set_table_comment :av_status_history, "The av_status_history table stores an entry for each pass searching for documents that need to be scanned."

    # bdmis_migrations
    set_table_comment :bdmis_migrations, "A table comment"
    set_column_comment :bdmis_migrations, :error_messages, "TBD"
    set_column_comment :bdmis_migrations, :approval_date, "TBD"
    set_column_comment :bdmis_migrations, :case_number, "TBD"
    set_column_comment :bdmis_migrations, :case_url, "TBD"
    set_column_comment :bdmis_migrations, :certification, "TBD"
    set_column_comment :bdmis_migrations, :company_name, "TBD"
    set_column_comment :bdmis_migrations, :decline_date, "TBD"
    set_column_comment :bdmis_migrations, :ein, "TBD"
    set_column_comment :bdmis_migrations, :next_review, "TBD"
    set_column_comment :bdmis_migrations, :office, "TBD"
    set_column_comment :bdmis_migrations, :page, "TBD"
    set_column_comment :bdmis_migrations, :status, "TBD"
    set_column_comment :bdmis_migrations, :submitted_on_date, "TBD"
    set_column_comment :bdmis_migrations, :exit_date, "TBD"
    set_column_comment :bdmis_migrations, :approved_date, "TBD"
    set_column_comment :bdmis_migrations, :office_code, "TBD"
    set_column_comment :bdmis_migrations, :office_name, "TBD"
    set_column_comment :bdmis_migrations, :district_code, "TBD"
    set_column_comment :bdmis_migrations, :district_name, "TBD"
    set_column_comment :bdmis_migrations, :duns, "TBD"
    set_column_comment :bdmis_migrations, :hashed_duns, "TBD"

    # business_partners
    # "id","sba_application_id","first_name","last_name","marital_status","address","city","state","postal_code","country","home_phone","business_phone","email","status","ssn","title","deleted_at","created_at","updated_at"
    set_table_comment :business_partners, "The business partners table stores information around the business partner. "
    set_column_comment :business_partners, :address, "Street address of the business partner. "
    set_column_comment :business_partners, :business_phone, "Business phone of the business partner."
    set_column_comment :business_partners, :city, "City of the business partner."
    set_column_comment :business_partners, :country, "Country of the business partner."
    set_column_comment :business_partners, :created_at, "Date and time the record was created. "
    set_column_comment :business_partners, :deleted_at, "Date and time the record was soft deleted."
    set_column_comment :business_partners, :email, "Business phone of the business partner."
    set_column_comment :business_partners, :first_name, "First name of the business partner."
    set_column_comment :business_partners, :home_phone, "Home phone of the business partner."
    set_column_comment :business_partners, :id, "Primary Key (serial) for record uniqueness. "
    set_column_comment :business_partners, :last_name, "Last name of the business partner."
    set_column_comment :business_partners, :postal_code, "Postal code of the business partner."
    set_column_comment :business_partners, :sba_application_id, "Foreign Key to the SBA Applications table."
    set_column_comment :business_partners, :ssn, "Social Security Number  of the business partner."
    set_column_comment :business_partners, :state, "State of the business partner."
    set_column_comment :business_partners, :status, "Status of the business partnet within the organization."
    set_column_comment :business_partners, :title, "Title phone of the business partner."
    set_column_comment :business_partners, :updated_at, "Date and time the record was last updated. "

    # business_types
    set_table_comment :business_types, "A table comment"

    # business_units
    set_table_comment :business_units, "A table comment"
    set_column_comment :business_units, :program_id, "TBD"
    set_column_comment :business_units, :title, "TBD"
    set_column_comment :business_units, :name, "TBD"

    # certificate_status_histories
    set_table_comment :certificate_status_histories, "The certificate_status_histories table stores the the history of changes made to certificates. "

    # certificate_status_types
    set_table_comment :certificate_status_types, "The certificate_status_types table stores the certificate status type offered by the SBA."

    # certificate_types
    # "id","name","description","deleted_at","created_at","updated_at","title","type","duration_in_days","wait_period_in_days","renewal_period_in_days","renewal_notification_period_in_days","annual_report_period_in_days"
    set_table_comment :certificate_types, "The certificate_types table stores the certification types offered by the SBA."
    set_column_comment :certificate_types, :created_at, "Date and time the record was created."
    set_column_comment :certificate_types, :deleted_at, "Date and time the record was soft deleted."
    set_column_comment :certificate_types, :description, "A description of the certificate types."
    set_column_comment :certificate_types, :id, "Primary Key (serial) for record uniqueness. "
    set_column_comment :certificate_types, :name, "Name of certificate."
    set_column_comment :certificate_types, :title, "Title of certificate."
    set_column_comment :certificate_types, :updated_at, "Date and time the record was last updated."
    set_column_comment :certificate_types, :renewal_notification_period_in_days, "TBD"
    set_column_comment :certificate_types, :annual_report_period_in_days, "TBD"

    # certificates
    # "id","organization_id","certificate_status_type_id","certificate_type_id","issue_date","expiry_date","deleted_at","created_at","updated_at","workflow_state","type","workflow_dirty","original_certificate_id","next_annual_report_date","duty_station_id"
    set_table_comment :certificates, "The certificates table stores the certificates offered by the SBA."
    set_column_comment :certificates, :certificate_status_type_id, "TBD"
    set_column_comment :certificates, :created_at, "TBD"
    set_column_comment :certificates, :deleted_at, "TBD"
    set_column_comment :certificates, :expiry_date, "TBD"
    set_column_comment :certificates, :id, "TBD"
    set_column_comment :certificates, :issue_date, "TBD"
    set_column_comment :certificates, :organization_id, "TBD"
    set_column_comment :certificates, :updated_at, "TBD"
    set_column_comment :certificates, :workflow_dirty, "TBD"
    set_column_comment :certificates, :original_certificate_id, "TBD"
    set_column_comment :certificates, :next_annual_report_date, "TBD"
    set_column_comment :certificates, :duty_station_id, "The id of the duty station that was selected for the 8a initial master application"

    # ckeditor_assets
    set_table_comment :ckeditor_assets, "A table comment"

    # contributors
    # "id","full_name","email","section_id","sba_application_id","position","section_name_type","expires_at","created_at","updated_at","deleted_at","user_id","sub_application_id"
    set_table_comment :contributors, "A table comment"
    set_column_comment :contributors, :id, "Primary Key (serial) for record uniqueness."
    set_column_comment :contributors, :full_name, "TBD"
    set_column_comment :contributors, :email, "TBD"
    set_column_comment :contributors, :section_id, "TBD"
    set_column_comment :contributors, :sba_application_id, "TBD"
    set_column_comment :contributors, :position, "TBD"
    set_column_comment :contributors, :section_name_type, "TBD"
    set_column_comment :contributors, :expires_at, "TBD"
    set_column_comment :contributors, :user_id, "The id of the User object that corresponds to this contributor"
    set_column_comment :contributors, :sub_application_id, "The id of the sub_application that this contributor has been invited to fill out"

    # countries
    set_table_comment :countries, "A table comment"

    # cron_job_histories
    set_table_comment :cron_job_histories, "A table comment"
    set_column_comment :cron_job_histories, :type, "TBD"
    set_column_comment :cron_job_histories, :start_time, "TBD"
    set_column_comment :cron_job_histories, :end_time, "TBD"

    # current_questionnaires
    # "id","certificate_type_id","questionnaire_id","kind","created_at","updated_at","for_testing"
    set_table_comment :current_questionnaires, "A table comment"
    set_column_comment :current_questionnaires, :id, "Primary Key (serial) for record uniqueness."
    set_column_comment :current_questionnaires, :certificate_type_id, "TBD"
    set_column_comment :current_questionnaires, :questionnaire_id, "TBD"
    set_column_comment :current_questionnaires, :kind, "TBD"
    set_column_comment :current_questionnaires, :for_testing, "this allows new questionnaires to be tested locally and in lower environments before being available in prod"

    # determinations
    # "id","decision","decider_id","deleted_at","created_at","updated_at","eligible"
    set_table_comment :determinations, "A table comment"
    set_column_comment :determinations, :id, "Primary Key (serial) for record uniqueness."

    # disqualifiers
    set_table_comment :disqualifiers, "A table comment"

    # document_type_questions
    set_table_comment :document_type_questions, "A table comment"

    # document_types
    set_table_comment :document_types, "The documents_types table is a list of possible documents types the user can select from. Birth Certificates, Operation Agreement or Doing Business As are examples of document type."

    # documents
    # "id","organization_id","stored_file_name","original_file_name","document_type_id","file_metadata","deleted_at","created_at","updated_at","comment","is_active","av_status","valid_pdf","user_id","is_analyst","compressed_status"
    set_table_comment :documents, "The documents tables holds the documents uploaded from the WOSB owner."
    set_column_comment :documents, :av_status, "Indicates the Anti Virus Scan status of the uploaded document."
    set_column_comment :documents, :comment, "Holds an comments user entered for the document."
    set_column_comment :documents, :created_at, "Date and time the record was created. "
    set_column_comment :documents, :deleted_at, "Date and time the record was soft deleted."
    set_column_comment :documents, :document_type_id, "Foreign Key to the Document Types table."
    set_column_comment :documents, :file_metadata, "Many data types and their relationships."
    set_column_comment :documents, :id, "Primary Key (serial) for record uniqueness. "
    set_column_comment :documents, :is_active, "A boolen indicating if the user is active."
    set_column_comment :documents, :organization_id, "Foreign Key to the Organizations table."
    set_column_comment :documents, :original_file_name, "Name of the file displayed to the user."
    set_column_comment :documents, :stored_file_name, "Name of the file assigned during legacy migration."
    set_column_comment :documents, :updated_at, "Date and time the record was last updated. "
    set_column_comment :documents, :valid_pdf, "Indicates if the PDF validation succeeded."
    set_column_comment :documents, :user_id, "Associate a document to the user that created/uploaded it"
    set_column_comment :documents, :compressed_status, "TBD"
    set_column_comment :documents, :is_analyst, "Indicates if the document was uploaded by an analyst"

    # duty_stations_sba_applications
    set_table_comment :duty_stations_sba_applications, "A table comment"

    # duty_stations
    set_table_comment :duty_stations, "A table comment"
    set_column_comment :duty_stations, :facility_code, "TBD"
    set_column_comment :duty_stations, :street_address, "TBD"
    set_column_comment :duty_stations, :city, "TBD"
    set_column_comment :duty_stations, :state, "TBD"
    set_column_comment :duty_stations, :zip, "TBD"
    set_column_comment :duty_stations, :region_code, "TBD"
    set_column_comment :duty_stations, :deleted_at, "TBD"
    set_column_comment :duty_stations, :name, "TBD"

    # eligibility_results
    set_table_comment :eligibility_results, "The eligibility_results table hold all the results when users complete the 'Am I Eligible' Survey."

    # eligible_naic_codes
    set_table_comment :eligible_naic_codes, "The eligible_naic_codes table is a list of NAIC Codes that are applicable to the WOSB/EDWOSB offerings."

    # email_notification_histories
    set_table_comment :email_notification_histories, "A table comment"
    set_column_comment :email_notification_histories, :program, "TBD"
    set_column_comment :email_notification_histories, :days, "TBD"
    set_column_comment :email_notification_histories, :organization_id, "TBD"
    set_column_comment :email_notification_histories, :email, "TBD"
    set_column_comment :email_notification_histories, :error, "Error message if there is an exception while creating or sending an 8(a) Annual Review Application / Notification"
    set_column_comment :email_notification_histories, :annual_review_sba_application_id, "8(a) Annual Review Application for successfully created applications"

    # evaluation_purposes
    # "id","name","title","certificate_type_id","questionnaire_id","deleted_at","explanations","created_at","updated_at"
    set_table_comment :evaluation_purposes, "Defines a grouping of applicable questions. For instance: Am I Eligible for WOSB, Am I Eligible for EDWOSB etc."
    set_column_comment :evaluation_purposes, :certificate_type_id, "Foreign Key to the Certificate Type table."
    set_column_comment :evaluation_purposes, :created_at, "Date and time the record was created."
    set_column_comment :evaluation_purposes, :deleted_at, "Date and time the record was soft deleted."
    set_column_comment :evaluation_purposes, :explanations, "Text of why you do or don't qualify."
    set_column_comment :evaluation_purposes, :id, "Primary Key (serial) for record uniqueness. "
    set_column_comment :evaluation_purposes, :name, "Evaluation purpose name."
    set_column_comment :evaluation_purposes, :questionnaire_id, "Foreign Key to the Questionnaires table."
    set_column_comment :evaluation_purposes, :title, "Title of evaluation purpose."
    set_column_comment :evaluation_purposes, :updated_at, "Date and time the record was last updated."

    # expiration_dates
    set_table_comment :expiration_dates, "A table comment"

    # groups
    set_table_comment :groups, "A table comment"

    # help_pages
    set_table_comment :help_pages, "A table comment"

    # notes
    # "id","notated_id","notated_type","title","body","author_id","published","deleted_at","created_at","updated_at","tags"
    set_table_comment :notes, "A table comment"
    set_column_comment :notes, :id, "Primary Key (serial) for record uniqueness."
    set_column_comment :notes, :tags, "these are tags that are associated with a document uploaded by an analyst"

    # office_locations
    set_table_comment :office_locations, "A table comment"
    set_column_comment :office_locations, :business_unit_id, "TBD"
    set_column_comment :office_locations, :user_id, "TBD"

    # office_requests
    set_table_comment :office_requests, "A table comment"
    set_column_comment :office_requests, :duty_station_id, "TBD"
    set_column_comment :office_requests, :access_request_id, "TBD"

    # offices
    set_table_comment :offices, "A table comment"
    set_column_comment :offices, :duty_station_id, "TBD"
    set_column_comment :offices, :user_id, "TBD"

    # organizations
    set_table_comment :organizations, "The organization table stores the Organizations."

    # permission_requests
    set_table_comment :permission_requests, "A table comment"
    set_column_comment :permission_requests, :access_request_id, "TBD"
    set_column_comment :permission_requests, :user_id, "TBD"

    # personnels
    set_table_comment :personnels, "A table comment"

    # programs
    set_table_comment :programs, "A table comment"

    # question_presentations
    # "id","question_id","section_id","position","tooltip","helpful_info","question_override_title","deleted_at","validation_rules","created_at","updated_at","disqualifier_id","repeater_label","minimum","maximum"
    set_table_comment :question_presentations, "The question_presentations table stores date about a question and how/what is presented to the user."
    set_column_comment :question_presentations, :created_at, "Date and time the record was created."
    set_column_comment :question_presentations, :deleted_at, "Date and time the record was soft deleted."
    set_column_comment :question_presentations, :helpful_info, "Content of question details and failure reasons."
    set_column_comment :question_presentations, :id, "Primary Key (serial) for record uniqueness. "
    set_column_comment :question_presentations, :position, "Order of question within a page."
    set_column_comment :question_presentations, :question_id, "Foreign Key to the Questions table."
    set_column_comment :question_presentations, :question_override_title, "Used when a question requires an over-ride."
    set_column_comment :question_presentations, :section_id, "Foreign Key to the Section table."
    set_column_comment :question_presentations, :tooltip, "Hover help text."
    set_column_comment :question_presentations, :updated_at, "Date and time the record was last updated. "
    set_column_comment :question_presentations, :validation_rules, "Used for front end javascript validations."

    # question_rules
    # "id","question_type_id","capability","mandatory","condition","value","deleted_at","created_at","updated_at"
    set_table_comment :question_rules, "The question_rules table stores any logic needed for question logic."
    set_column_comment :question_rules, :capability, "Controls if a comment or attachment is needed."
    set_column_comment :question_rules, :condition, "Used to determine the presentation of a comment or attachment."
    set_column_comment :question_rules, :created_at, "Date and time the record was created. "
    set_column_comment :question_rules, :deleted_at, "Date and time the record was soft deleted."
    set_column_comment :question_rules, :id, "Primary Key (serial) for record uniqueness."
    set_column_comment :question_rules, :mandatory, "Determines if a comment or question is required."
    set_column_comment :question_rules, :question_type_id, "Foreign Key to the Questions Type table."
    set_column_comment :question_rules, :updated_at, "Date and time the record was last updated."
    set_column_comment :question_rules, :value, "Controls the expected value to be presented."

    # question_types
    # "id","name","description","deleted_at","created_at","updated_at","title","type","config_options"
    set_table_comment :question_types, "The question_types is a grouping of question based on type."
    set_column_comment :question_types, :created_at, "Date and time the record was created. "
    set_column_comment :question_types, :deleted_at, "Date and time the record was soft deleted."
    set_column_comment :question_types, :description, "A description of the question types."
    set_column_comment :question_types, :id, "Primary Key (serial) for record uniqueness. "
    set_column_comment :question_types, :name, "Name of question."
    set_column_comment :question_types, :title, "Title of question."
    set_column_comment :question_types, :type, "Type of question."
    set_column_comment :question_types, :updated_at, "Date and time the record was last updated."

    # questionnaire_histories
    set_table_comment :questionnaire_histories, "A table comment"
    set_column_comment :questionnaire_histories, :certificate_type_id, "TBD"
    set_column_comment :questionnaire_histories, :questionnaire_id, "TBD"
    set_column_comment :questionnaire_histories, :kind, "TBD"
    set_column_comment :questionnaire_histories, :version, "TBD"

    # questionnaires
    # "id","name","title","submit_text","confirm","anonymous","determine_eligibility","display_title","single_page","deleted_at","created_at","updated_at","root_section_id","first_section_id","program_id","maximum_allowed","certificate_type_id","initial_app","vendor_can_start","analyst_can_start","review_page_display_title","link_label","human_name","type","scheduler_can_start","prerequisite_order"
    set_table_comment :questionnaires, "The questionnaires table stores questionnaire details."
    set_column_comment :questionnaires, :anonymous, "Identifies if the questionnaire is pre or post login."
    set_column_comment :questionnaires, :confirm, "Used to determine if the confirmation page should be displayed."
    set_column_comment :questionnaires, :created_at, "Date and time the record was created. "
    set_column_comment :questionnaires, :deleted_at, "Date and time the record was soft deleted."
    set_column_comment :questionnaires, :determine_eligibility, "Used to control display of all questions or eligibility."
    set_column_comment :questionnaires, :display_title, "Header for questionnaire."
    set_column_comment :questionnaires, :first_section_id, "Indicates the first section of the questionaire."
    set_column_comment :questionnaires, :id, "Primary Key (serial) for record uniqueness."
    set_column_comment :questionnaires, :name, "Name of questionnaire."
    set_column_comment :questionnaires, :root_section_id, "Indicates the root section of the questionnaire."
    set_column_comment :questionnaires, :single_page, "Used to identify of the questionnaire is single page or not."
    set_column_comment :questionnaires, :submit_text, "Text for the submit button."
    set_column_comment :questionnaires, :title, "Title of questionnaire."
    set_column_comment :questionnaires, :updated_at, "Date and time the record was last updated."
    set_column_comment :questionnaires, :review_page_display_title, "The display title on the review page"
    set_column_comment :questionnaires, :link_label, "The label used when linking to this questionnaire"
    set_column_comment :questionnaires, :human_name, "The human name or short name used to refer to the questionnaire (EDWOSB, etc.)"
    set_column_comment :questionnaires, :maximum_allowed, "same as in certificate type - moved here because there can be different types of questionnaires: initial, annual review, etc."
    set_column_comment :questionnaires, :type, "For subclassing questionnaires"
    set_column_comment :questionnaires, :certificate_type_id, "support for multiple questionnaires per cert type"
    set_column_comment :questionnaires, :initial_app, "is this questionnaire used as the 'initial application' vendors fill out (with future support for multiple simultaneous)"
    set_column_comment :questionnaires, :prerequisite_order, "TBD"
    set_column_comment :questionnaires, :vendor_can_start, "TBD"
    set_column_comment :questionnaires, :analyst_can_start, "TBD"
    set_column_comment :questionnaires, :scheduler_can_start, "TBD"

    # questions
    # "id","name","description","question_type_id","deleted_at","title","multi","helpful_info","sub_questions","possible_values","created_at","updated_at","strategy","prepopulate","title_wrapper_tag"
    set_table_comment :questions, "The questions table stores all questions needed to be answered when attempting to become certified."
    set_column_comment :questions, :created_at, "Date and time the record was created."
    set_column_comment :questions, :deleted_at, "Date and time the record was soft deleted."
    set_column_comment :questions, :description, "A description of the questions."
    set_column_comment :questions, :helpful_info, "Where we stuff all the extra json details that we use for questions - mostly used for failure messages."
    set_column_comment :questions, :id, "Primary Key (serial) for record uniqueness. "
    set_column_comment :questions, :multi, "Does this question have more than one answer?  An array of the same answer type"
    set_column_comment :questions, :name, "Name of question."
    set_column_comment :questions, :possible_values, "For pick lists?  What is the list of possible values to choose from?"
    set_column_comment :questions, :question_type_id, "Foreign Key to the Questions Type table."
    set_column_comment :questions, :strategy, "What algorithm to use for calculating totals / massaging the final value that is stored for an answer."
    set_column_comment :questions, :sub_questions, "For complex questions - like personal property, where there are a number of questions on the page with complex interdependencies, this field holds all the information for the subquestions, which is used to create 'virtual questions' in the application"
    set_column_comment :questions, :title, "	Title of question."
    set_column_comment :questions, :updated_at, "Date and time the record was last updated."
    set_column_comment :questions, :title_wrapper_tag, "Adding the ability to wrap a question title with somthing other than h3"
    set_column_comment :questions, :prepopulate, "TBD"

    # reviews
    # "id","type","case_number","sba_application_id","certificate_id","current_assignment_id","workflow_state","determination_id","deleted_at","created_at","updated_at","workflow_dirty","screening_due_date","processing_due_date","recommend_eligible","recommend_eligible_for_appeal","determine_eligible","determine_eligible_for_appeal","processing_paused","processing_pause_date","letter_due_date","reconsideration_or_appeal_clock"
    set_table_comment :reviews, "A table comment"
    set_column_comment :reviews, :id, "Primary Key (serial) for record uniqueness."
    set_column_comment :reviews, :determine_eligible, "TBD"
    set_column_comment :reviews, :determine_eligible_for_appeal, "TBD"
    set_column_comment :reviews, :workflow_dirty, "TBD"
    set_column_comment :reviews, :screening_due_date, "The due date for the screening"
    set_column_comment :reviews, :processing_due_date, "TBD"
    set_column_comment :reviews, :processing_paused, "flag that indicates if the review processing has been paused"
    set_column_comment :reviews, :processing_pause_date, "The date that processing was paused"
    set_column_comment :reviews, :letter_due_date, "TBD"
    set_column_comment :reviews, :reconsideration_or_appeal_clock, "Date by which the user has to submit an appeal or reconsideration"

    # roles
    set_table_comment :roles, "The roles table stores user assigned roles."

    # sba_application_documents
    set_table_comment :sba_application_documents, "The sba_application_documents table stores all documents associated to the application."

    # sba_applications
    # "id","application_status_type_id","organization_id","application_start_date","deleted_at","created_at","updated_at","progress","signature","application_submitted_at","root_section_id","first_section_id","renewal","workflow_state","version_number","current_sba_application_id","is_current","sam_snapshot","certificate_id","questionnaire_id","type","master_application_id","position","kind","current_section_id","zip_file_status","prerequisite_order","workflow_dirty","returned_by","original_certificate_id","adhoc_question_title","adhoc_question_details","screening_due_date","returned_reviewer_id","creator_id","unanswered_adhoc_reviews","bdmis_case_number","review_for","review_number"
    set_table_comment :sba_applications, "The sba_applications table stores all certification applications submitted to the SBA."
    set_column_comment :sba_applications, :application_start_date, "Date and time of when the application was started."
    set_column_comment :sba_applications, :application_status_type_id, "	Foreign Key to the Application Status Type table."
    set_column_comment :sba_applications, :application_submitted_at, "Timestamp of when the application was submitted"
    set_column_comment :sba_applications, :created_at, "Date and time the record was created. "
    set_column_comment :sba_applications, :deleted_at, "Date and time the record was soft deleted."
    set_column_comment :sba_applications, :first_section_id, "Indicates the first section of the application."
    set_column_comment :sba_applications, :id, "Primary Key (serial) for record uniqueness. "
    set_column_comment :sba_applications, :organization_id, "Foreign Key to the Organizations table."
    set_column_comment :sba_applications, :progress, "Measures progress of the application."
    set_column_comment :sba_applications, :root_section_id, "Indicates the root section of the application."
    set_column_comment :sba_applications, :signature, "Holds the signature from the application. This is from the signature section which is not stored as Answers"
    set_column_comment :sba_applications, :updated_at, "Date and time the record was last updated. "
    set_column_comment :sba_applications, :master_application_id, "TBD"
    set_column_comment :sba_applications, :position, "TBD"
    set_column_comment :sba_applications, :questionnaire_id, "each app needs to associate directly to a questionnaire instead of a cert type"
    set_column_comment :sba_applications, :type, "For subclassing applications"
    set_column_comment :sba_applications, :current_section_id, "Used to track the current section for sub applications so you can quickly get back to that section from the master app"
    set_column_comment :sba_applications, :zip_file_status, "Status of Zip file of all documents. 0 - Not Created, 1 - Pending, 2 - Ready. Refer story APP-473"
    set_column_comment :sba_applications, :prerequisite_order, "TBD"
    set_column_comment :sba_applications, :workflow_dirty, "TBD"
    set_column_comment :sba_applications, :kind, "TBD"
    #set_column_comment :sba_applications, :unanswered_adhoc_reviews, "TBD"
    set_column_comment :sba_applications, :adhoc_question_title, "TBD"
    set_column_comment :sba_applications, :adhoc_question_details, "TBD"
    set_column_comment :sba_applications, :screening_due_date, "The due date for the screening"
    set_column_comment :sba_applications, :returned_reviewer_id, "TBD"
    set_column_comment :sba_applications, :original_certificate_id, "TBD"
    set_column_comment :sba_applications, :returned_by, "Track the last case owner who returned this application to vendor"
    set_column_comment :sba_applications, :bdmis_case_number, "The BDMIS case number"
    set_column_comment :sba_applications, :review_for, "The date the annual review is set for."
    set_column_comment :sba_applications, :review_number, "The number of the review, 1 thru 8."
    set_column_comment :sba_applications, :creator_id, "User id of the person that created the application"

    # schema_migrations
    set_table_comment :schema_migrations, "The schema_migrations table stores information to track the migration scripts."

    # section_rules
    # "id","questionnaire_id","from_section_id","to_section_id","deleted_at","created_at","updated_at","skip_info","expression","sba_application_id","template_root_id","dynamic","is_last","is_multi_path_template","terminal_section_id","generated_from_id"
    set_table_comment :section_rules, "The section_rules table stores all the logic for each section."
    set_column_comment :section_rules, :created_at, "Date and time the record was created."
    set_column_comment :section_rules, :deleted_at, "Date and time the record was soft deleted."
    set_column_comment :section_rules, :dynamic, "Is this section rule for a dynamic section (created from Form 413)."
    set_column_comment :section_rules, :expression, "Expression to check if this rule applies to current state."
    set_column_comment :section_rules, :from_section_id, "Controls which section to move backwards to."
    set_column_comment :section_rules, :id, "Primary Key (serial) for record uniqueness. "
    set_column_comment :section_rules, :is_last, "Is this the last rule?  - used to determine when to continue to the regular section rules after handling dynamic sections."
    set_column_comment :section_rules, :questionnaire_id, "Foreign Key to the Questionnaires table."
    set_column_comment :section_rules, :sba_application_id, "Foreign Key to the SBA Applications table."
    set_column_comment :section_rules, :skip_info, "Controls any sections that are NA."
    set_column_comment :section_rules, :template_root_id, "If this section rule relates to a template section, what is the root of the template tree."
    set_column_comment :section_rules, :to_section_id, "Controls which section to move forward to."
    set_column_comment :section_rules, :updated_at, "Date and time the record was last updated."

    # sections
    # "id","name","description","sba_application_id","ancestry","deleted_at","created_at","updated_at","title","submit_text","questionnaire_id","type","template_id","repeat","displayable","position","answered_for_id","answered_for_type","original_section_id","dynamic","template_type","validation_rules","is_applicable","is_completed","review_position","sub_sections_completed","sub_sections_applicable","defer_applicability_for_id","sub_questionnaire_id","sub_application_id","status","prescreening","is_last","related_to_section_id"
    set_table_comment :sections, "The sections table store each section of an application."
    set_column_comment :sections, :ancestry, "This records the parents of this section."
    set_column_comment :sections, :answered_for_id, "For dynamic sections, the model id (business partner id) that this section is associated with."
    set_column_comment :sections, :answered_for_type, "For dynamic sections, the model type (BusinessPartner)."
    set_column_comment :sections, :created_at, "Date and time the record was created. "
    set_column_comment :sections, :deleted_at, "Date and time the record was soft deleted."
    set_column_comment :sections, :description, "A description of the sections."
    set_column_comment :sections, :displayable, "Template sections are not displayed in the UI - just used for creating other sections - so they're not displable"
    set_column_comment :sections, :dynamic, "Is this a dynamic section that was created from a template?"
    set_column_comment :sections, :id, "Primary Key (serial) for record uniqueness."
    set_column_comment :sections, :is_applicable, "Indicates if the section is applicable based on previous responses."
    set_column_comment :sections, :is_completed, "Indicates if the section is completed based on responses."
    set_column_comment :sections, :name, "Name of section."
    set_column_comment :sections, :original_section_id, "When an application is created the sections are copied from the questionnaire - so each application has it's own hierarchy.  The original section refers to the section in the questionnaire.that corresponds to this section. Used to proxy the questions / question presentations"
    set_column_comment :sections, :position, "Order the section is displayed in the tree."
    set_column_comment :sections, :questionnaire_id, "Foreign Key to the Questionnaires table."
    set_column_comment :sections, :repeat, "Is this a repeating section (Form 413) where you can have a list of the same section (one for each business partner)"
    set_column_comment :sections, :sba_application_id, "Foreign Key to the SBA Applications table."
    set_column_comment :sections, :submit_text, "Text that should appear on the Submit button on the page."
    set_column_comment :sections, :template_id, "For dynamic sections (Form 413) this references the original template that was used to create the section"
    set_column_comment :sections, :template_type, "What is the subtype of the template, so you can dynamically create different types of sections (question section, review section, etc)."
    set_column_comment :sections, :title, "Title of the section."
    set_column_comment :sections, :type, "Type of section."
    set_column_comment :sections, :updated_at, "Date and time the record was last updated."
    set_column_comment :sections, :validation_rules, "Used for front end javascript validations."
    set_column_comment :sections, :sub_questionnaire_id, "For master questionnaires to have sub questionnaires"
    set_column_comment :sections, :sub_application_id, "For master applications to have sub applicationss"
    set_column_comment :sections, :status, "Used for sub applications to determine if the app has been started, is in progress or has been completed"
    set_column_comment :sections, :prescreening, "This will be used for any sub-sections / sub applications that are to be completed BEFORE reaching the master 8a questionnaire"
    set_column_comment :sections, :is_last, "Used to determine which page to use to submit the application (sub apps submit from review, where others submit from signature)"
    set_column_comment :sections, :related_to_section_id, "for adhoc questionnaires - they are related to other subsections in the application"

    # sessions
    set_table_comment :sessions, "The sessions table holds an entry for each user session opened. If closed correctly the entry is removed."

    # users_roles
    set_table_comment :users_roles, "The users _roles table stores the roles of the users."

    # users
    # "id","email","deleted_at","created_at","updated_at","encrypted_password","reset_password_token","reset_password_sent_at","sign_in_count","current_sign_in_at","last_sign_in_at","current_sign_in_ip","last_sign_in_ip","confirmation_token","confirmed_at","confirmation_sent_at","unconfirmed_email","failed_attempts","unlock_token","locked_at","first_name","last_name","phone_number","provider","uid","max_user_classification","max_agency","max_org_tag","max_group_list","max_id","max_first_name","max_security_level_list","max_last_name","max_email","max_bureau","roles_map"
    set_table_comment :users, "The users table stores all user that login to the system."
    set_column_comment :users, :confirmation_sent_at, "Timestamp of when the confirmation email was sent."
    set_column_comment :users, :confirmation_token, "Unique token generated when the user signs up and is sent an email to confirm account."
    set_column_comment :users, :confirmed_at, "Timestamp of when the account was confirmed."
    set_column_comment :users, :created_at, "Date and time the record was created."
    set_column_comment :users, :current_sign_in_ip, "IP address of the current sign in"
    set_column_comment :users, :deleted_at, "Date and time the record was soft deleted."
    set_column_comment :users, :email, "Email address of the user."
    set_column_comment :users, :encrypted_password, "Password salted and encrypted. Uses bcrypt algorithm"
    set_column_comment :users, :failed_attempts, "Number of failed sign in attempts the user has had"
    set_column_comment :users, :first_name, "User's first name."
    set_column_comment :users, :id, "Primary Key (serial) for record uniqueness."
    set_column_comment :users, :last_name, "User's last name."
    set_column_comment :users, :last_sign_in_ip, "IP address of the last sign in"
    set_column_comment :users, :locked_at, "Timestamp of when the account was locked"
    set_column_comment :users, :phone_number, "User's phone number."
    set_column_comment :users, :reset_password_sent_at, "Timestamp of when the reset password request was initiated"
    set_column_comment :users, :reset_password_token, "Unique token generated when user requests for a password reset"
    set_column_comment :users, :sign_in_count, "Number of successful Sign Ins the user has had to the system"
    set_column_comment :users, :unconfirmed_email, "NOT USED"
    set_column_comment :users, :unlock_token, "Unique token generated when the user requests to unlock account. "
    set_column_comment :users, :updated_at, "Date and time the record was last updated. "
    set_column_comment :users, :roles_map, "this is the user hash where the roles will be saved"
  end
end