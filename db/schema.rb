# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20211004220057) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_requests", force: :cascade, comment: "Tracks access requests by contracting officers to review a specific organization" do |t|
    t.integer  "user_id",                          comment: "Foreign Key to the Users table. The CO making the request."
    t.integer  "organization_id",                  comment: "Foreign Key to the Organizations table. The org they're requesting access to"
    t.text     "solicitation_number",              comment: "The solicitation number - ask mary"
    t.text     "solicitation_naics",               comment: "The solicitation naics - ask mary"
    t.text     "procurement_type",                 comment: "The procurement type - ask mary"
    t.text     "status",                           comment: "The current status of the Access Request. Possible values include Requested, Accepted, Rejected, Revoked or Expired."
    t.date     "accepted_on",                      comment: "The date the request was accepted"
    t.date     "request_expires_on",               comment: "The date when the request expires."
    t.date     "access_expires_on",                comment: "The date the access itself expires"
    t.datetime "deleted_at",                       comment: "Date and time the record was soft deleted."
    t.datetime "created_at",          null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",          null: false, comment: "Date and time the record was last updated."
    t.string   "type",                             comment: "The class that this request belongs to."
    t.integer  "role_id",                          comment: "Foreign Key to the Roles table."
    t.json     "roles_map",                        comment: "this is the user hash where the roles will be saved"
  end

  add_index "access_requests", ["access_expires_on"], name: "index_access_requests_on_access_expires_on", using: :btree
  add_index "access_requests", ["organization_id"], name: "index_access_requests_on_organization_id", using: :btree
  add_index "access_requests", ["request_expires_on"], name: "index_access_requests_on_request_expires_on", using: :btree
  add_index "access_requests", ["solicitation_naics"], name: "index_access_requests_on_solicitation_naics", using: :btree
  add_index "access_requests", ["solicitation_number"], name: "index_access_requests_on_solicitation_number", using: :btree
  add_index "access_requests", ["status"], name: "index_access_requests_on_status", using: :btree
  add_index "access_requests", ["user_id"], name: "index_access_requests_on_user_id", using: :btree

  create_table "agency_contract_types", force: :cascade, comment: "This table stores the contract types available to an agency requirement" do |t|
    t.text     "name",       null: false, comment: "The name of the contract type"
    t.datetime "deleted_at",              comment: "Date and time the record was soft deleted."
    t.datetime "created_at", null: false, comment: "Date and time the record was created."
    t.datetime "updated_at", null: false, comment: "Date and time the record was last updated."
  end

  add_index "agency_contract_types", ["deleted_at"], name: "index_agency_contract_types_on_deleted_at", using: :btree

  create_table "agency_cos", force: :cascade, comment: "Contract officers assigned to an agency" do |t|
    t.text     "first_name", null: false, comment: "The first name of the contract officer"
    t.text     "last_name",  null: false, comment: "The last name of the contract officer assigned to an agency"
    t.text     "phone",                   comment: "The phone number of the contract officer assigned to an agency"
    t.text     "email",                   comment: "The email of the contract officer assigned to an agency"
    t.text     "address1",                comment: "The address of the contract officer assigned to an agency"
    t.text     "address2",                comment: "The address of the contract officer assigned to an agency"
    t.text     "city",                    comment: "The city where the contract officer assigned to an agency is located"
    t.text     "state",                   comment: "The state where the contract officer assigned to an agency is located"
    t.text     "zip",                     comment: "The zip code of the contract officer assigned to an agency"
    t.datetime "deleted_at",              comment: "Date and time the record was soft deleted."
    t.datetime "created_at", null: false, comment: "Date and time the record was created."
    t.datetime "updated_at", null: false, comment: "Date and time the record was last updated."
  end

  add_index "agency_cos", ["deleted_at"], name: "index_agency_cos_on_deleted_at", using: :btree

  create_table "agency_naics_codes", force: :cascade, comment: "List of all NAICS codes" do |t|
    t.text     "code",            null: false, comment: "The numeric code"
    t.text     "industry_title",               comment: "The name of the industry associated with the NAICS code"
    t.text     "size_dollars_mm",              comment: "SBA size standard expressed in millions of dollars"
    t.text     "size_employees",               comment: "SBA size standard expressed in number of employees"
    t.datetime "deleted_at",                   comment: "Date and time the record was soft deleted."
    t.datetime "created_at",      null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",      null: false, comment: "Date and time the record was last updated."
  end

  add_index "agency_naics_codes", ["code"], name: "index_agency_naics_codes_on_code", using: :btree
  add_index "agency_naics_codes", ["deleted_at"], name: "index_agency_naics_codes_on_deleted_at", using: :btree

  create_table "agency_offer_agreements", force: :cascade, comment: "List of agreement types" do |t|
    t.text     "name",       null: false, comment: "Name of the agreement type"
    t.datetime "deleted_at",              comment: "Date and time the record was soft deleted."
    t.datetime "created_at", null: false, comment: "Date and time the record was created."
    t.datetime "updated_at", null: false, comment: "Date and time the record was last updated."
  end

  add_index "agency_offer_agreements", ["deleted_at"], name: "index_agency_offer_agreements_on_deleted_at", using: :btree

  create_table "agency_offer_codes", force: :cascade, comment: "List of offer codes" do |t|
    t.text     "name",       null: false, comment: "Name of the code"
    t.datetime "deleted_at",              comment: "Date and time the record was soft deleted."
    t.datetime "created_at", null: false, comment: "Date and time the record was created."
    t.datetime "updated_at", null: false, comment: "Date and time the record was last updated."
  end

  add_index "agency_offer_codes", ["deleted_at"], name: "index_agency_offer_codes_on_deleted_at", using: :btree

  create_table "agency_offer_scopes", force: :cascade, comment: "The geographic scope of an offer" do |t|
    t.text     "name",       null: false, comment: "Name of the geographic scope."
    t.datetime "deleted_at",              comment: "Date and time the record was soft deleted."
    t.datetime "created_at", null: false, comment: "Date and time the record was created."
    t.datetime "updated_at", null: false, comment: "Date and time the record was last updated."
  end

  add_index "agency_offer_scopes", ["deleted_at"], name: "index_agency_offer_scopes_on_deleted_at", using: :btree

  create_table "agency_offices", force: :cascade, comment: "List of Federal Agencies and Departments" do |t|
    t.text     "name",         null: false, comment: "Full name of the federal agency or department"
    t.text     "abbreviation",              comment: "Abbreviation of the federal agency or department"
    t.datetime "deleted_at",                comment: "Date and time the record was soft deleted."
    t.datetime "created_at",   null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",   null: false, comment: "Date and time the record was last updated."
  end

  add_index "agency_offices", ["deleted_at"], name: "index_agency_offices_on_deleted_at", using: :btree

  create_table "agency_requirement_documents", force: :cascade, comment: "Mapping of an agency requirement and an associated document" do |t|
    t.integer  "user_id",                                              comment: "Associate a document to the user that created/uploaded it"
    t.integer  "agency_requirement_id",                                comment: "Primary key of the agency requirement"
    t.text     "stored_file_name",                                     comment: "Name of the file assigned during legacy migration."
    t.text     "original_file_name",                                   comment: "Name of the file displayed to the user."
    t.text     "document_type",                                        comment: "Chosen from AgencyRequirementDocument::AGENCY_DOCUMENT_TYPES."
    t.json     "file_metadata",                                        comment: "Many data types and their relationships."
    t.datetime "updated_at",                              null: false, comment: "Date and time the record was last updated."
    t.text     "comment",                                              comment: "Holds an comments user entered for the document."
    t.boolean  "is_active",             default: false,                comment: "A boolen indicating if the user is active."
    t.text     "av_status",                                            comment: "Indicates the Anti Virus Scan status of the uploaded document."
    t.boolean  "valid_pdf",                                            comment: "Indicates if the PDF validation succeeded."
    t.string   "compressed_status",     default: "ready",              comment: "Indicates if document compression has succeeded or failed"
    t.datetime "deleted_at",                                           comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                              null: false, comment: "Date and time the record was created."
  end

  add_index "agency_requirement_documents", ["deleted_at"], name: "index_agency_requirement_documents_on_deleted_at", using: :btree

  create_table "agency_requirement_organizations", force: :cascade, comment: "List of agency requirement and an associated organization" do |t|
    t.integer  "agency_requirement_id", comment: "Primary key of the agency requirement"
    t.integer  "organization_id",       comment: "Primary key of the associated organization"
    t.datetime "deleted_at",            comment: "Date and time the record was soft deleted."
    t.datetime "created_at",            comment: "Date and time the record was created."
    t.datetime "updated_at",            comment: "Date and time the record was last updated."
  end

  add_index "agency_requirement_organizations", ["agency_requirement_id", "organization_id", "deleted_at"], name: "aro_3col_uni_idx", unique: true, where: "(deleted_at IS NOT NULL)", using: :btree
  add_index "agency_requirement_organizations", ["agency_requirement_id", "organization_id"], name: "aro_2col_uni_idx", unique: true, where: "(deleted_at IS NULL)", using: :btree
  add_index "agency_requirement_organizations", ["agency_requirement_id"], name: "index_agency_requirement_organizations_on_agency_requirement_id", using: :btree
  add_index "agency_requirement_organizations", ["organization_id"], name: "index_agency_requirement_organizations_on_organization_id", using: :btree

  create_table "agency_requirements", force: :cascade, comment: "List of Agency Requirements" do |t|
    t.integer  "user_id",                                                                         comment: "Foreign Key to the Users table."
    t.integer  "duty_station_id",                                                                 comment: "Foreign Key to the Duty Stations table."
    t.integer  "program_id",                                                                      comment: "Foreign Key to the Programs table."
    t.integer  "agency_naics_code_id",                                                            comment: "Foreign Key to the Agency NAICS Codes table."
    t.integer  "agency_office_id",                                                   null: false, comment: "Foreign Key to the Agency Offices table."
    t.integer  "agency_offer_code_id",                                                            comment: "Foreign Key to the Agency Offer Codes table."
    t.integer  "agency_offer_scope_id",                                                           comment: "Foreign Key to the Agency Offer Scopes table."
    t.integer  "agency_offer_agreement_id",                                                       comment: "Foreign Key to the Agency Offer Agreements table."
    t.integer  "agency_contract_type_id",                                                         comment: "Foreign Key to the Agency Contract Types table."
    t.integer  "agency_co_id",                                                                    comment: "Foreign Key to the Agency COs table."
    t.text     "title",                                                              null: false, comment: "Name of the company"
    t.text     "description",                                                                     comment: "Description of the work to be performed."
    t.date     "received_on",                                                                     comment: "When the requirement was received by the SBA."
    t.decimal  "estimated_contract_value",  precision: 15, scale: 2,                              comment: "An estimate of the amount to be awarded."
    t.decimal  "contract_value",            precision: 15, scale: 2,                              comment: "The actual amount that was awarded."
    t.text     "offer_solicitation_number"
    t.text     "offer_value"
    t.text     "contract_number"
    t.text     "agency_comments",                                                                 comment: "Comments about the agency"
    t.text     "contract_comments",                                                               comment: "Comments about the contract"
    t.text     "comments",                                                                        comment: "Additional Comments"
    t.boolean  "contract_awarded",                                   default: false, null: false, comment: "Indicates if contract was awarded."
    t.datetime "deleted_at",                                                                      comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                                                         null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",                                                         null: false, comment: "Date and time the record was last updated."
    t.text     "unique_number",                                                      null: false, comment: "autogenerated unique identifier that can be used to refer to an agency requirement, in the format of <A-Z><A-Z><timestamp><A-Z> (two uppercase letters followed by a timestamp number followed by an uppercase letter)"
    t.string   "case_number",                                                                     comment: "The case number on the e8a database"
    t.datetime "e8a_created_at",                                                                  comment: "When it was created in the e8a database"
    t.datetime "e8a_deleted_at",                                                                  comment: "When it was deleted in the e8a database"
  end

  add_index "agency_requirements", ["agency_co_id"], name: "index_agency_requirements_on_agency_co_id", using: :btree
  add_index "agency_requirements", ["agency_contract_type_id"], name: "index_agency_requirements_on_agency_contract_type_id", using: :btree
  add_index "agency_requirements", ["agency_naics_code_id"], name: "index_agency_requirements_on_agency_naics_code_id", using: :btree
  add_index "agency_requirements", ["agency_offer_agreement_id"], name: "index_agency_requirements_on_agency_offer_agreement_id", using: :btree
  add_index "agency_requirements", ["agency_offer_code_id"], name: "index_agency_requirements_on_agency_offer_code_id", using: :btree
  add_index "agency_requirements", ["agency_offer_scope_id"], name: "index_agency_requirements_on_agency_offer_scope_id", using: :btree
  add_index "agency_requirements", ["agency_office_id"], name: "index_agency_requirements_on_agency_office_id", using: :btree
  add_index "agency_requirements", ["deleted_at"], name: "index_agency_requirements_on_deleted_at", using: :btree
  add_index "agency_requirements", ["duty_station_id"], name: "index_agency_requirements_on_duty_station_id", using: :btree
  add_index "agency_requirements", ["program_id"], name: "index_agency_requirements_on_program_id", using: :btree
  add_index "agency_requirements", ["user_id"], name: "index_agency_requirements_on_user_id", using: :btree

  create_table "annual_reports", force: :cascade, comment: "Used to model MPP annual renewal" do |t|
    t.integer  "certificate_id",                  comment: "Foreign Key to the Certificate table."
    t.integer  "sba_application_id",              comment: "Foreign Key to the SBA Applications table."
    t.string   "status",                          comment: "Current status of the annual report. Possible values include Approved, Declined or Returned"
    t.integer  "reviewer_id",                     comment: "Foreign Key to the Users table."
    t.datetime "created_at",         null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",         null: false, comment: "Date and time the record was last updated."
  end

  create_table "anonymous_users", force: :cascade, comment: "The anonymous_user stores a record for every user that take the am-i-eligible survey." do |t|
    t.datetime "deleted_at", comment: "Date and time the record was soft deleted."
    t.datetime "created_at", comment: "Date and time the record was created."
    t.datetime "updated_at", comment: "Date and time the record was last updated."
  end

  add_index "anonymous_users", ["deleted_at"], name: "index_anonymous_users_on_deleted_at", using: :btree

  create_table "answer_documents", force: :cascade, comment: "The answer_documents table are documents that are added by answer for further information." do |t|
    t.integer  "answer_id",   null: false, comment: "Foreign Key to the Answers table."
    t.integer  "document_id", null: false, comment: "Foreign Key to the Document table."
    t.datetime "deleted_at",               comment: "Date and time the record was soft deleted."
    t.datetime "created_at",               comment: "Date and time the record was created."
    t.datetime "updated_at",               comment: "Date and time the record was last updated."
  end

  add_index "answer_documents", ["answer_id", "document_id", "deleted_at"], name: "answer_doc_answer_id_doc_id", unique: true, using: :btree
  add_index "answer_documents", ["deleted_at"], name: "index_answer_documents_on_deleted_at", using: :btree
  add_index "answer_documents", ["document_id", "answer_id", "deleted_at"], name: "UK_certification_answer_document", unique: true, using: :btree

  create_table "answers", force: :cascade, comment: "The answers table tracks the responses provided by a user." do |t|
    t.text     "type",                            comment: "Type of application (WOSB, EDWOSB, 8(a) etc.). (might be changed to a text column)."
    t.integer  "owner_id",                        comment: "Composite key (owner_id and owner_type) indicates either the Users or the Anonymous Users table. "
    t.text     "owner_type",                      comment: "User identification role."
    t.integer  "sba_application_id",              comment: "Foreign Key to the SBA Applications table."
    t.integer  "question_id",        null: false, comment: "Foreign Key to the Questions table."
    t.text     "evaluated_response",              comment: "Response which determines which answer is correct."
    t.text     "response",                        comment: "Answer provided by the user."
    t.text     "comment",                         comment: "Field for users to add additional notes to their answers."
    t.datetime "deleted_at",                      comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                      comment: "Date and time the record was created. "
    t.datetime "updated_at",                      comment: "Date and time the record was last updated. "
    t.json     "value",                           comment: "Aggregated response for the answer. With introduction of Form 413 questions, this has been changed to a json type to handle complex responses with more that one value."
    t.json     "details",                         comment: "Detailed response for the answer. Json type to hold complex responses."
    t.integer  "answered_for_id",                 comment: "Indicates who or for whom the answer was entered."
    t.text     "answered_for_type",               comment: "The type of table the ID is associated with. "
  end

  add_index "answers", ["deleted_at"], name: "index_answers_on_deleted_at", using: :btree
  add_index "answers", ["owner_type", "owner_id"], name: "index_answers_on_owner_type_and_owner_id", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["sba_application_id", "owner_type", "owner_id", "answered_for_type", "answered_for_id", "question_id", "deleted_at"], name: "UK_answers", unique: true, using: :btree
  add_index "answers", ["sba_application_id", "owner_type", "owner_id", "answered_for_type", "answered_for_id", "question_id", "deleted_at"], name: "i_answers_on_owner_quest_answered4", unique: true, using: :btree

  create_table "applicable_questions", force: :cascade, comment: "The applicable_questions table is a list of questions asked to become certified." do |t|
    t.integer  "evaluation_purpose_id", null: false, comment: "Foreign Key to the Evaluation Purposes table."
    t.integer  "question_id",           null: false, comment: "Foreign Key to the Questions table."
    t.text     "positive_response",                  comment: "Indicates which response from the user that is considered successful"
    t.json     "lookup",                             comment: "Hash used to lookup NAICS code"
    t.datetime "deleted_at",                         comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                         comment: "Date and time the record was created."
    t.datetime "updated_at",                         comment: "Date and time the record was last updated."
  end

  add_index "applicable_questions", ["deleted_at"], name: "index_applicable_questions_on_deleted_at", using: :btree
  add_index "applicable_questions", ["evaluation_purpose_id", "question_id", "deleted_at"], name: "app_quest_eval_purp_quest_idx", unique: true, using: :btree
  add_index "applicable_questions", ["question_id", "evaluation_purpose_id", "deleted_at"], name: "UK_applicable_question", unique: true, using: :btree

  create_table "application_status_histories", force: :cascade, comment: "The application_status_histories stores the history of each certification." do |t|
    t.integer  "sba_application_id",         null: false
    t.integer  "application_status_type_id", null: false
    t.datetime "status_reached_at",          null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "application_status_histories", ["deleted_at"], name: "index_application_status_histories_on_deleted_at", using: :btree
  add_index "application_status_histories", ["sba_application_id", "application_status_type_id", "deleted_at"], name: "UK_application_status_histories", unique: true, using: :btree
  add_index "application_status_histories", ["sba_application_id", "application_status_type_id", "deleted_at"], name: "index_app_status_id", unique: true, using: :btree

  create_table "application_status_types", force: :cascade, comment: "The application_status_types stores the different status an certification can have." do |t|
    t.text     "name",        null: false, comment: "Short name of the status type"
    t.text     "description", null: false, comment: "Long form of the status type"
    t.datetime "deleted_at",               comment: "Date and time the record was soft deleted."
    t.datetime "created_at",               comment: "Date and time the record was created."
    t.datetime "updated_at",               comment: "Date and time the record was last updated."
  end

  add_index "application_status_types", ["deleted_at"], name: "index_application_status_types_on_deleted_at", using: :btree
  add_index "application_status_types", ["name", "deleted_at"], name: "UK_application_status_type", unique: true, using: :btree

  create_table "assessments", force: :cascade, comment: "The assessments table is where analysts store their notes and statuses on specific questions and sections of a questionnaire" do |t|
    t.integer  "review_id",                           comment: "Foreign Key to the Reviews table."
    t.integer  "note_id",                             comment: "Foreign Key to the Notes table."
    t.integer  "assessed_by_id",                      comment: "Foreign Key to the Users table. The assessor - analyst - a user"
    t.string   "the_assessed_type",                   comment: "The thing we're assessing."
    t.integer  "the_assessed_id",                     comment: "The id of that thing we're assessing."
    t.string   "status",                              comment: "Current status of the Assessment. Possible values include 'Confirmed', 'Not reviewed', 'Information missing', 'Makes vendor ineligible' or Needs 'further review'."
    t.datetime "deleted_at",                          comment: "Date and time the record was soft deleted."
    t.datetime "created_at",             null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",             null: false, comment: "Date and time the record was last updated."
    t.string   "determination_decision",              comment: "Stores the current determination decision"
    t.integer  "new_reviewer_id",                     comment: "Foreign Key to the Users table. Stores the id of the new current reviewer"
  end

  add_index "assessments", ["deleted_at"], name: "index_assessments_on_deleted_at", using: :btree
  add_index "assessments", ["the_assessed_id"], name: "index_assessments_on_the_assessed_id", using: :btree
  add_index "assessments", ["the_assessed_type"], name: "index_assessments_on_the_assessed_type", using: :btree

  create_table "assignments", force: :cascade, comment: "Stores the different users that are assigned to a review" do |t|
    t.integer  "review_id",                  comment: "Foreign Key to the Reviews table."
    t.integer  "supervisor_id",              comment: "Foreign Key to the Users table."
    t.integer  "owner_id",                   comment: "Foreign Key to the Users table."
    t.integer  "reviewer_id",                comment: "Foreign Key to the Users table."
    t.datetime "deleted_at",                 comment: "Date and time the record was soft deleted."
    t.datetime "created_at",    null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",    null: false, comment: "Date and time the record was last updated."
  end

  add_index "assignments", ["owner_id", "deleted_at"], name: "index_assignments_on_ownd", using: :btree
  add_index "assignments", ["review_id", "deleted_at"], name: "index_assignments_on_reviewd", using: :btree
  add_index "assignments", ["reviewer_id", "deleted_at"], name: "index_assignments_on_revd", using: :btree
  add_index "assignments", ["supervisor_id", "deleted_at"], name: "index_assignments_on_supd", using: :btree

  create_table "av_status_history", force: :cascade, comment: "The av_status_history table stores an entry for each pass searching for documents that need to be scanned." do |t|
    t.datetime "start_time",      comment: "When the scan started."
    t.datetime "end_time",        comment: "When the scan ended."
    t.integer  "total_documents", comment: "The number of documents being scanned."
    t.integer  "total_errors",    comment: "The number of errors that occurred during the scan."
    t.text     "error_message",   comment: "The error message if applicable"
    t.datetime "deleted_at",      comment: "Date and time the record was soft deleted."
    t.datetime "created_at",      comment: "Date and time the record was created."
    t.datetime "updated_at",      comment: "Date and time the record was last updated."
  end

  add_index "av_status_history", ["deleted_at"], name: "index_av_status_history_on_deleted_at", using: :btree

  create_table "bdmis_migrations", force: :cascade, comment: "Used to store data about applications that were previously stored in BDMIS" do |t|
    t.integer  "sba_application_id",                  comment: "Foreign Key to the SBA Applications table."
    t.text     "error_messages"
    t.date     "approval_date"
    t.text     "case_number"
    t.text     "case_url"
    t.text     "certification"
    t.text     "company_name"
    t.date     "decline_date"
    t.text     "ein"
    t.date     "next_review"
    t.integer  "office"
    t.integer  "page"
    t.text     "status"
    t.datetime "submitted_on_date"
    t.date     "exit_date"
    t.date     "approved_date"
    t.integer  "office_code"
    t.text     "office_name"
    t.integer  "district_code"
    t.text     "district_name"
    t.text     "duns"
    t.text     "hashed_duns"
    t.datetime "created_at",             null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",             null: false, comment: "Date and time the record was last updated."
    t.text     "current_assigned_email",              comment: "New columns from the BDMIS csv import"
    t.text     "last_recommendation",                 comment: "New columns from the BDMIS csv import"
  end

  add_index "bdmis_migrations", ["sba_application_id"], name: "index_bdmis_migrations_on_sba_application_id", using: :btree

  create_table "business_partners", force: :cascade, comment: "The business partners table stores information around the business partner. " do |t|
    t.integer  "sba_application_id", null: false, comment: "Foreign Key to the SBA Applications table."
    t.text     "first_name",         null: false, comment: "First name of the business partner."
    t.text     "last_name",          null: false, comment: "Last name of the business partner."
    t.integer  "marital_status",                  comment: "Marital status of the business partner."
    t.text     "address",                         comment: "Street address of the business partner. "
    t.text     "city",                            comment: "City of the business partner."
    t.text     "state",                           comment: "State of the business partner."
    t.text     "postal_code",                     comment: "Postal code of the business partner."
    t.text     "country",                         comment: "Country of the business partner."
    t.text     "home_phone",                      comment: "Home phone of the business partner."
    t.text     "business_phone",                  comment: "Business phone of the business partner."
    t.text     "email",                           comment: "Business phone of the business partner."
    t.integer  "status",                          comment: "Status of the business partnet within the organization."
    t.text     "ssn",                null: false, comment: "Social Security Number  of the business partner."
    t.integer  "title",                           comment: "Title phone of the business partner."
    t.datetime "deleted_at",                      comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                      comment: "Date and time the record was created."
    t.datetime "updated_at",                      comment: "Date and time the record was last updated."
  end

  add_index "business_partners", ["sba_application_id", "first_name", "last_name", "ssn", "deleted_at"], name: "UK_business_partners", unique: true, using: :btree
  add_index "business_partners", ["sba_application_id", "first_name", "last_name", "ssn", "deleted_at"], name: "index_business_partners", unique: true, using: :btree

  create_table "business_types", force: :cascade, comment: "The different business types that can be certified" do |t|
    t.string   "name",                      comment: "Name of the business type for system use."
    t.string   "display_name",              comment: "Name of business type for presentation on the screen."
    t.datetime "created_at",   null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",   null: false, comment: "Date and time the record was last updated."
  end

  create_table "business_units", force: :cascade, comment: "Departments within the SBA" do |t|
    t.string   "name",                    comment: "Name of the business unit for internal system use"
    t.datetime "created_at", null: false, comment: "Date and time the record was created."
    t.datetime "updated_at", null: false, comment: "Date and time the record was last updated."
    t.datetime "deleted_at",              comment: "Date and time the record was soft deleted."
    t.integer  "program_id",              comment: "Foreign Key to the Programs table."
    t.string   "title",                   comment: "Display name of the business unit"
  end

  create_table "certificate_status_histories", force: :cascade, comment: "The certificate_status_histories table stores the the history of changes made to certificates." do |t|
    t.integer  "certificate_id",             null: false
    t.integer  "certificate_status_type_id", null: false
    t.datetime "status_reached_at",          null: false
    t.datetime "deleted_at",                              comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                              comment: "Date and time the record was created."
    t.datetime "updated_at",                              comment: "Date and time the record was last updated."
  end

  add_index "certificate_status_histories", ["certificate_id", "certificate_status_type_id", "deleted_at"], name: "UK_certificate_status_histories", unique: true, using: :btree
  add_index "certificate_status_histories", ["certificate_id", "certificate_status_type_id", "deleted_at"], name: "index_cert_status_id", unique: true, using: :btree
  add_index "certificate_status_histories", ["deleted_at"], name: "index_certificate_status_histories_on_deleted_at", using: :btree

  create_table "certificate_status_types", force: :cascade, comment: "The status types that a certificate can be in." do |t|
    t.text     "name",        null: false, comment: "The name of the status type"
    t.text     "description", null: false, comment: "The description of the status type"
    t.datetime "deleted_at",               comment: "Date and time the record was soft deleted."
    t.datetime "created_at",               comment: "Date and time the record was created."
    t.datetime "updated_at",               comment: "Date and time the record was last updated."
  end

  add_index "certificate_status_types", ["deleted_at"], name: "index_certificate_status_types_on_deleted_at", using: :btree
  add_index "certificate_status_types", ["name", "deleted_at"], name: "UK_certificate_ststus_type", unique: true, using: :btree

  create_table "certificate_types", force: :cascade, comment: "The certificate_types table stores the certification types offered by the SBA." do |t|
    t.text     "name",                                null: false, comment: "Name of certificate."
    t.text     "description",                                      comment: "A description of the certificate types."
    t.datetime "deleted_at",                                       comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                                       comment: "Date and time the record was created."
    t.datetime "updated_at",                                       comment: "Date and time the record was last updated."
    t.text     "title",                               null: false, comment: "Title of certificate."
    t.string   "type",                                             comment: "Sub-class of certificate: WOSB, MPP, etc."
    t.integer  "duration_in_days",                                 comment: "How long the cert lasts"
    t.integer  "wait_period_in_days",                              comment: "How long the vendor needs to wait before recertifying"
    t.integer  "renewal_period_in_days",                           comment: "How long the vendor needs to wait to renew"
    t.integer  "renewal_notification_period_in_days",              comment: "How many days in advance of their renewal date that the vendor gets a notification."
    t.integer  "annual_report_period_in_days",                     comment: "Number of days between annual reports. Spoiler alert...365"
  end

  add_index "certificate_types", ["deleted_at"], name: "index_certificate_types_on_deleted_at", using: :btree
  add_index "certificate_types", ["name", "deleted_at"], name: "certificate_type_ukey", unique: true, using: :btree
  add_index "certificate_types", ["name", "deleted_at"], name: "index_certificate_types_on_name_and_deleted_at", unique: true, using: :btree

  create_table "certificates", force: :cascade, comment: "The certificates table stores the certificates offered by the SBA." do |t|
    t.integer  "organization_id",                            null: false, comment: "Foreign Key to the Organizations table."
    t.integer  "certificate_status_type_id",                              comment: "Foreign Key to the Certificate Status Types table."
    t.integer  "certificate_type_id",                        null: false, comment: "Foreign Key to the Certificate Types table."
    t.datetime "issue_date",                                              comment: "When the certificate was created."
    t.datetime "expiry_date",                                             comment: "When the certificate expires"
    t.datetime "deleted_at",                                              comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                                              comment: "Date and time the record was created."
    t.datetime "updated_at",                                              comment: "Date and time the record was last updated."
    t.text     "workflow_state",                                          comment: "The current state in the lifecycle of the certificate"
    t.string   "type",                                                    comment: "Subclass of this certificate"
    t.boolean  "workflow_dirty",             default: false,              comment: "Attribute used to make the workflow gem work with Elasticsearch"
    t.integer  "original_certificate_id",                                 comment: "THIS COLUMN IS NEEDED IN THE INTERIM TO TIE ANNUAL RENEWAL (ANNUAL REPORT) CERTS TO THE ORIGINAL CERTIFICATE THAT WAS CREATED FOR THEM"
    t.date     "next_annual_report_date",                                 comment: "When the next MPP annual report is due"
    t.integer  "duty_station_id",                                         comment: "The id of the duty station that was selected for the 8a initial master application"
    t.boolean  "suspended",                  default: false,              comment: "Migrated from BDMIS to be used later"
    t.text     "current_assigned_email",                                  comment: "Migrated from BDMIS to be used later for review assignment"
    t.integer  "servicing_bos_id",                                        comment: "the user id of the person who serves as the servicing BOS"
    t.boolean  "rejected",                   default: false,              comment: "Last recommendation from BDMIS to be used later"
  end

  add_index "certificates", ["certificate_status_type_id"], name: "index_certificates_on_certificate_status_type_id", using: :btree
  add_index "certificates", ["certificate_type_id", "organization_id", "issue_date", "deleted_at"], name: "UK_certificate2", unique: true, using: :btree
  add_index "certificates", ["certificate_type_id", "organization_id", "issue_date", "deleted_at"], name: "index_certificate_cert_type_org_issue", unique: true, using: :btree
  add_index "certificates", ["certificate_type_id"], name: "index_certificates_on_certificate_type_id", using: :btree
  add_index "certificates", ["organization_id"], name: "index_certificates_on_organization_id", using: :btree

  create_table "ckeditor_assets", force: :cascade, comment: "A table comment" do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.string   "data_fingerprint"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",                   null: false, comment: "Date and time the record was last updated."
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "contributors", force: :cascade, comment: "Users that a person filling out a certification application has asked to fill out a contributor application" do |t|
    t.string   "full_name",                       comment: "Fullname of the contributor"
    t.string   "email",                           comment: "Email of the contributor"
    t.integer  "section_id",                      comment: "Foreign Key to the Sections table."
    t.integer  "sba_application_id",              comment: "Foreign Key to the SBA Applications table."
    t.integer  "position",                        comment: "The numerical order in which the contributor request was made"
    t.string   "section_name_type",               comment: "The name of the section that is the template for this contributor's questionnaire"
    t.datetime "expires_at",                      comment: "When the email request sent to the contributor expires."
    t.datetime "created_at",         null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",         null: false, comment: "Date and time the record was last updated."
    t.datetime "deleted_at",                      comment: "Date and time the record was soft deleted."
    t.integer  "user_id",                         comment: "The id of the User object that corresponds to this contributor"
    t.integer  "sub_application_id",              comment: "The id of the sub_application that this contributor has been invited to fill out"
  end

  create_table "countries", force: :cascade, comment: "List of all recognized countries" do |t|
    t.text     "name",            null: false, comment: "Full name of the country"
    t.text     "iso_alpha2_code", null: false, comment: "2 letter country code"
    t.datetime "deleted_at",                   comment: "Date and time the record was soft deleted."
    t.datetime "created_at",      null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",      null: false, comment: "Date and time the record was last updated."
  end

  create_table "cron_job_histories", force: :cascade, comment: "Log of cron job that have run" do |t|
    t.string   "type",                    comment: "The command used to run the cron job."
    t.datetime "start_time",              comment: "When the cron job started."
    t.datetime "end_time",                comment: "When the cron job ended."
    t.datetime "created_at", null: false, comment: "Date and time the record was created."
    t.datetime "updated_at", null: false, comment: "Date and time the record was last updated."
  end

  create_table "current_questionnaires", force: :cascade do |t|
    t.integer  "certificate_type_id",                              comment: "Foreign Key to the Certificate Types table."
    t.integer  "questionnaire_id",                                 comment: "Foreign Key to the Questionnaires table."
    t.string   "kind",                                             comment: "Indicates if the currently active questionnaire is an initial or annual review."
    t.datetime "created_at",                          null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",                          null: false, comment: "Date and time the record was last updated."
    t.boolean  "for_testing",         default: false,              comment: "this allows new questionnaires to be tested locally and in lower environments before being available in prod"
  end

  add_index "current_questionnaires", ["certificate_type_id"], name: "index_current_questionnaires_on_certificate_type_id", using: :btree
  add_index "current_questionnaires", ["questionnaire_id"], name: "index_current_questionnaires_on_questionnaire_id", using: :btree

  create_table "determinations", force: :cascade, comment: "Records the decision made after a review" do |t|
    t.integer  "decision",                comment: "The outcome of the determination. Possible values include 'SBA Declined' or 'SBA Approved'"
    t.integer  "decider_id",              comment: "Foreign Key to the Users table. The person making the determination."
    t.datetime "deleted_at",              comment: "Date and time the record was soft deleted."
    t.datetime "created_at", null: false, comment: "Date and time the record was created."
    t.datetime "updated_at", null: false, comment: "Date and time the record was last updated."
    t.boolean  "eligible",                comment: "There are multiple determination outcomes, all of which are still considered 'eligible'. This flag makes it more obvious which are which"
  end

  add_index "determinations", ["decider_id", "deleted_at"], name: "index_determ_on_decid_d", using: :btree

  create_table "disqualifiers", force: :cascade, comment: "Questions whose answer can disqualify an applicant" do |t|
    t.text     "value",                   comment: "The answer that will activate the disqualifier"
    t.text     "message",                 comment: "The message that explains why the answer is disqualifying"
    t.datetime "created_at", null: false, comment: "Date and time the record was created."
    t.datetime "updated_at", null: false, comment: "Date and time the record was last updated."
  end

  create_table "document_type_questions", force: :cascade, comment: "Mapping between a question and the document types that can be uploaded to it." do |t|
    t.integer  "document_type_id", null: false, comment: "Foreign Key to the Document Types table."
    t.integer  "question_id",      null: false, comment: "Foreign Key to the Questions table."
    t.datetime "deleted_at",                    comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                    comment: "Date and time the record was created."
    t.datetime "updated_at",                    comment: "Date and time the record was last updated."
  end

  add_index "document_type_questions", ["document_type_id", "question_id", "deleted_at"], name: "UK_document_type_questions", unique: true, using: :btree
  add_index "document_type_questions", ["document_type_id", "question_id", "deleted_at"], name: "index_document_type_questions_on_question_id", using: :btree

  create_table "document_types", force: :cascade, comment: "List of possible documents types the user can select from. Birth Certificates, Operation Agreement or Doing Business As are examples of document type." do |t|
    t.text     "name",        null: false, comment: "Name of the document."
    t.text     "description",              comment: "Description of the document."
    t.datetime "created_at",               comment: "Date and time the record was created."
    t.datetime "updated_at",               comment: "Date and time the record was last updated."
    t.datetime "deleted_at",               comment: "Date and time the record was soft deleted."
  end

  add_index "document_types", ["name", "deleted_at"], name: "UK_document_type", unique: true, using: :btree
  add_index "document_types", ["name", "deleted_at"], name: "index_document_types_on_deleted_at", using: :btree

  create_table "documents", force: :cascade, comment: "The documents tables holds the documents uploaded from the WOSB owner." do |t|
    t.integer  "organization_id",                      null: false, comment: "Foreign Key to the Organizations table."
    t.text     "stored_file_name",                     null: false, comment: "Name of the file assigned during legacy migration."
    t.text     "original_file_name",                   null: false, comment: "Name of the file displayed to the user."
    t.integer  "document_type_id",                     null: false, comment: "Foreign Key to the Document Types table."
    t.json     "file_metadata",                                     comment: "Many data types and their relationships."
    t.datetime "deleted_at",                                        comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                                        comment: "Date and time the record was created. "
    t.datetime "updated_at",                                        comment: "Date and time the record was last updated. "
    t.text     "comment",                                           comment: "Holds an comments user entered for the document."
    t.boolean  "is_active",                            null: false, comment: "A boolen indicating if the user is active."
    t.text     "av_status",                            null: false, comment: "Indicates the Anti Virus Scan status of the uploaded document."
    t.boolean  "valid_pdf",                                         comment: "Indicates if the PDF validation succeeded."
    t.integer  "user_id",                                           comment: "Associate a document to the user that created/uploaded it"
    t.boolean  "is_analyst",         default: false,                comment: "Indicates if the document was uploaded by an analyst"
    t.string   "compressed_status",  default: "ready",              comment: "TBD"
  end

  add_index "documents", ["av_status", "compressed_status"], name: "index_documents_on_av_status_and_compressed_status", using: :btree
  add_index "documents", ["av_status"], name: "index_documents_on_av_status", using: :btree
  add_index "documents", ["deleted_at"], name: "index_documents_on_deleted_at", using: :btree
  add_index "documents", ["document_type_id"], name: "index_documents_on_document_type_id", using: :btree
  add_index "documents", ["organization_id", "document_type_id", "stored_file_name", "deleted_at"], name: "UK_document", unique: true, using: :btree
  add_index "documents", ["organization_id", "document_type_id", "stored_file_name", "deleted_at"], name: "index_documents_on_orgid_doctypeid_originalfilename", unique: true, using: :btree
  add_index "documents", ["organization_id"], name: "index_documents_on_organization_id", using: :btree
  add_index "documents", ["user_id"], name: "index_documents_on_user_id", using: :btree

  create_table "duty_stations", force: :cascade, comment: "The location of an employee's official worksite." do |t|
    t.string   "facility_code",               comment: "9 digit code used to identify a duty station"
    t.string   "street_address",              comment: "Address of the duty station"
    t.string   "city",                        comment: "City where duty station is located"
    t.string   "state",                       comment: "State where duty station is located"
    t.string   "zip",                         comment: "Zip code of the duty station"
    t.string   "region_code",                 comment: "The SBA region that the duty station is located."
    t.datetime "deleted_at",                  comment: "Date and time the record was soft deleted."
    t.datetime "created_at",     null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",     null: false, comment: "Date and time the record was last updated."
    t.string   "name",                        comment: "Name of the duty station"
  end

  add_index "duty_stations", ["deleted_at"], name: "index_duty_stations_on_deleted_at", using: :btree

  create_table "duty_stations_sba_applications", force: :cascade, comment: "A table comment" do |t|
    t.integer "sba_application_id"
    t.integer "duty_station_id"
  end

  create_table "e8a_migrations", force: :cascade do |t|
    t.text     "unique_number",               comment: "AgencyRequirement.unique number, RqmtLtrTbl.RqmtNmb in e8a"
    t.text     "error_messages"
    t.jsonb    "fields"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "e8a_migrations", ["unique_number"], name: "index_e8a_migrations_on_unique_number", using: :btree

  create_table "eligibility_results", force: :cascade, comment: "The eligibility_results table hold all the results when users complete the 'Am I Eligible' Survey." do |t|
    t.integer  "evaluation_purpose_id", null: false
    t.integer  "owner_id",              null: false
    t.text     "owner_type",            null: false
    t.boolean  "result",                null: false
    t.text     "reason"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "eligibility_results", ["deleted_at"], name: "index_eligibility_results_on_deleted_at", using: :btree
  add_index "eligibility_results", ["evaluation_purpose_id", "owner_type", "owner_id", "deleted_at"], name: "UK_eligibility", unique: true, using: :btree
  add_index "eligibility_results", ["evaluation_purpose_id", "owner_type", "owner_id", "deleted_at"], name: "index_eligibility_results_on_eval_purp_and_owner", unique: true, using: :btree

  create_table "eligible_naic_codes", force: :cascade, comment: "The eligible_naic_codes table is a list of NAIC Codes that are applicable to the WOSB/EDWOSB offerings." do |t|
    t.integer  "certificate_type_id",   null: false, comment: "Foreign Key to the Certificate Type table."
    t.text     "naic_code",             null: false, comment: "The numeric code"
    t.text     "naic_code_description", null: false, comment: "The name of the industry associated with the NAICS code"
    t.datetime "deleted_at",                         comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                         comment: "Date and time the record was created."
    t.datetime "updated_at",                         comment: "Date and time the record was last updated."
  end

  add_index "eligible_naic_codes", ["certificate_type_id", "naic_code", "deleted_at"], name: "UK_eligible_naic_code", unique: true, using: :btree
  add_index "eligible_naic_codes", ["deleted_at"], name: "index_eligible_naic_codes_on_deleted_at", using: :btree
  add_index "eligible_naic_codes", ["naic_code", "certificate_type_id", "deleted_at"], name: "index_naic_codes_on_naic_code_and_cert_type", unique: true, using: :btree

  create_table "email_notification_histories", force: :cascade, comment: "Log of Email Notifications sent to a vendor" do |t|
    t.string   "program",                                       comment: "The program for which the email notification was sent."
    t.integer  "days",                                          comment: "Number of days until certificate expiration."
    t.integer  "organization_id",                               comment: "Foreign Key to the Organizations table."
    t.string   "email",                                         comment: "The email of the recipient."
    t.datetime "created_at",                       null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",                       null: false, comment: "Date and time the record was last updated."
    t.string   "error",                                         comment: "Error message if there is an exception while creating or sending an 8(a) Annual Review Application / Notification"
    t.integer  "annual_review_sba_application_id",              comment: "8(a) Annual Review Application for successfully created applications"
  end

  create_table "evaluation_histories", force: :cascade, comment: "A log of evaluation decisions" do |t|
    t.string   "category",       null: false, comment: "The type of evaluation"
    t.string   "value",          null: false, comment: "The evaluation decision"
    t.string   "stage",          null: false, comment: "The evaluation stage."
    t.integer  "evaluable_id",   null: false, comment: "Foreign Key to the table of the object that is being evaluated."
    t.integer  "evaluator_id",   null: false, comment: "Foreign Key to the Users table."
    t.datetime "deleted_at",                  comment: "Date and time the record was soft deleted."
    t.datetime "created_at",     null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",     null: false, comment: "Date and time the record was last updated."
    t.string   "evaluable_type",              comment: "The type of model that is being evaluated"
  end

  add_index "evaluation_histories", ["deleted_at"], name: "index_evaluation_histories_on_deleted_at", using: :btree
  add_index "evaluation_histories", ["evaluable_id", "evaluable_type"], name: "index_evaluation_histories_on_evaluable_id_and_evaluable_type", using: :btree
  add_index "evaluation_histories", ["evaluable_id"], name: "index_evaluation_histories_on_evaluable_id", using: :btree
  add_index "evaluation_histories", ["evaluator_id"], name: "index_evaluation_histories_on_evaluator_id", using: :btree

  create_table "evaluation_purposes", force: :cascade, comment: "Defines a grouping of applicable questions. For instance: Am I Eligible for WOSB, Am I Eligible for EDWOSB etc." do |t|
    t.text     "name",                null: false, comment: "Evaluation purpose name."
    t.text     "title",                            comment: "Title of evaluation purpose."
    t.integer  "certificate_type_id",              comment: "Foreign Key to the Certificate Type table."
    t.integer  "questionnaire_id",                 comment: "Foreign Key to the Questionnaires table."
    t.datetime "deleted_at",                       comment: "Date and time the record was soft deleted."
    t.json     "explanations",                     comment: "Text of why you do or don't qualify."
    t.datetime "created_at",                       comment: "Date and time the record was created."
    t.datetime "updated_at",                       comment: "Date and time the record was last updated."
  end

  add_index "evaluation_purposes", ["name", "certificate_type_id", "deleted_at"], name: "eval_purpose_name_cert_uniq_idx", unique: true, using: :btree
  add_index "evaluation_purposes", ["name", "certificate_type_id", "deleted_at"], name: "evaluation_purposes_ukey", unique: true, using: :btree

  create_table "event_logs", force: :cascade, comment: "Generic event log" do |t|
    t.integer  "loggable_id",                comment: "The associated model"
    t.string   "loggable_type",              comment: "The associated model"
    t.integer  "user_id",                    comment: "The user who generated the event, if any"
    t.text     "event",                      comment: "The event that is being logged"
    t.text     "comment",                    comment: "Additional text annotation"
    t.datetime "created_at",    null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",    null: false, comment: "Date and time the record was last updated."
  end

  add_index "event_logs", ["loggable_id", "loggable_type"], name: "index_event_logs_on_loggable_id_and_loggable_type", using: :btree
  add_index "event_logs", ["user_id"], name: "index_event_logs_on_user_id", using: :btree

  create_table "expiration_dates", force: :cascade, comment: "Used to change expiration dates for access requests" do |t|
    t.text     "type",                       comment: "Not used"
    t.text     "model",                      comment: "Name of the other table whose expiration dates we're overriding"
    t.text     "field",                      comment: "Name of the specific field in the other table"
    t.text     "days_from_now",              comment: "The number of days until this expiration"
    t.datetime "created_at",    null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",    null: false, comment: "Date and time the record was last updated."
  end

  create_table "groups", force: :cascade, comment: "Used to filter the types of applications sba staff can see - the only types of groups discussed so far are regional offices for the 8a program." do |t|
    t.integer  "program_id",              comment: "Foreign Key to the Programs table."
    t.text     "name",                    comment: "Short name of the group."
    t.text     "title",                   comment: "Full name of the group for display."
    t.datetime "deleted_at",              comment: "Date and time the record was soft deleted."
    t.datetime "created_at", null: false, comment: "Date and time the record was created."
    t.datetime "updated_at", null: false, comment: "Date and time the record was last updated."
  end

  add_index "groups", ["program_id"], name: "index_groups_on_program_id", using: :btree

  create_table "help_pages", force: :cascade, comment: "Used to display FAQ-style content (no longer used)" do |t|
    t.text     "title",                    comment: "Content for title section"
    t.text     "left_panel",               comment: "Content for left panel"
    t.text     "right_panel",              comment: "Content for right panel"
    t.datetime "created_at",  null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",  null: false, comment: "Date and time the record was last updated."
  end

  create_table "notes", force: :cascade, comment: "Notes that a user has written. Can be associated with any object in the system." do |t|
    t.integer  "notated_id",                comment: "Foreign Key to the object's table."
    t.text     "notated_type",              comment: "The object that the note is for."
    t.text     "title",                     comment: "The title of the note"
    t.text     "body",                      comment: "The main text of the note"
    t.integer  "author_id",                 comment: "Foreign Key to the Users table."
    t.boolean  "published",                 comment: "Indicates if the note is visible"
    t.datetime "deleted_at",                comment: "Date and time the record was soft deleted."
    t.datetime "created_at",   null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",   null: false, comment: "Date and time the record was last updated."
    t.json     "tags",                      comment: "these are tags that are associated with a document uploaded by an analyst"
  end

  add_index "notes", ["author_id", "deleted_at"], name: "index_notes_on_author_d", using: :btree
  add_index "notes", ["notated_type", "notated_id", "deleted_at"], name: "index_notes_on_notated", using: :btree

  create_table "office_locations", force: :cascade, comment: "Mapping between a user and the business unit where they are located." do |t|
    t.integer  "business_unit_id", null: false, comment: "Foreign Key to the Business Units table."
    t.integer  "user_id",          null: false, comment: "Foreign Key to the Users table."
    t.datetime "deleted_at",                    comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                    comment: "Date and time the record was created."
    t.datetime "updated_at",                    comment: "Date and time the record was last updated."
  end

  create_table "office_requests", force: :cascade, comment: "Mapping between Access Requests and Duty Stations" do |t|
    t.integer  "duty_station_id",   null: false, comment: "Foreign Key to the Duty Stations table."
    t.integer  "access_request_id", null: false, comment: "Foreign Key to the Access Requests table."
    t.datetime "deleted_at",                     comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                     comment: "Date and time the record was created."
    t.datetime "updated_at",                     comment: "Date and time the record was last updated."
  end

  create_table "offices", force: :cascade, comment: "Mapping between users and their associated duty stations" do |t|
    t.integer  "duty_station_id", null: false, comment: "Foreign Key to the Duty Stations table."
    t.integer  "user_id",         null: false, comment: "Foreign Key to the Users table."
    t.datetime "deleted_at",                   comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                   comment: "Date and time the record was created."
    t.datetime "updated_at",                   comment: "Date and time the record was last updated."
  end

  create_table "organizations", force: :cascade, comment: "The businesses that desire to be certified by the SBA." do |t|
    t.text     "duns_number",         null: false, comment: "The DUNS number associated with a business"
    t.text     "tax_identifier",      null: false, comment: "The tax identification number for this organization"
    t.text     "tax_identifier_type", null: false, comment: "The type of tax identification for this organization. Typically SSN or EIN."
    t.text     "business_type",       null: false, comment: "The corporate form that this organization was incorporated as."
    t.datetime "deleted_at",                       comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                       comment: "Date and time the record was created."
    t.datetime "updated_at",                       comment: "Date and time the record was last updated."
    t.text     "folder_name",         null: false, comment: "A randomly generated alpanumeric string used to identify the S3 bucket for this organization"
  end

  add_index "organizations", ["deleted_at"], name: "index_organizations_on_deleted_at", using: :btree
  add_index "organizations", ["duns_number", "tax_identifier", "tax_identifier_type", "deleted_at"], name: "UK_organization", unique: true, using: :btree
  add_index "organizations", ["duns_number", "tax_identifier", "tax_identifier_type", "deleted_at"], name: "index_org_duns_tax_ident_and_type", unique: true, using: :btree
  add_index "organizations", ["folder_name", "deleted_at"], name: "organization_hash", unique: true, using: :btree

  create_table "permission_requests", force: :cascade, comment: "Mapping between a user and their access request" do |t|
    t.integer  "access_request_id",             null: false, comment: "Foreign Key to the Access Requests table."
    t.integer  "user_id",                       null: false, comment: "Foreign Key to the Users table."
    t.datetime "deleted_at",                                 comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                                 comment: "Date and time the record was created."
    t.datetime "updated_at",                                 comment: "Date and time the record was last updated."
    t.integer  "action",            default: 0
  end

  create_table "personnels", force: :cascade, comment: "Mapping between a user and the organization they belong to" do |t|
    t.integer  "organization_id", comment: "Foreign Key to the Organizations table."
    t.integer  "user_id",         comment: "Foreign Key to the Users table."
    t.datetime "deleted_at",      comment: "Date and time the record was soft deleted."
    t.datetime "created_at",      comment: "Date and time the record was created."
    t.datetime "updated_at",      comment: "Date and time the record was last updated."
  end

  create_table "programs", force: :cascade, comment: "The programs that the Certify app is used by." do |t|
    t.text     "name",                    comment: "Short version of program name. Used internally by system."
    t.text     "title",                   comment: "Full name of the program for display"
    t.datetime "deleted_at",              comment: "Date and time the record was soft deleted."
    t.datetime "created_at", null: false, comment: "Date and time the record was created."
    t.datetime "updated_at", null: false, comment: "Date and time the record was last updated."
  end

  create_table "question_presentations", force: :cascade, comment: "The question_presentations table stores date about a question and how/what is presented to the user." do |t|
    t.integer  "question_id",             null: false, comment: "Foreign Key to the Questions table."
    t.integer  "section_id",              null: false, comment: "Foreign Key to the Section table."
    t.integer  "position",                             comment: "Order of question within a page."
    t.text     "tooltip",                              comment: "Hover help text."
    t.json     "helpful_info",                         comment: "Content of question details and failure reasons."
    t.text     "question_override_title",              comment: "Used when a question requires an over-ride."
    t.datetime "deleted_at",                           comment: "Date and time the record was soft deleted."
    t.json     "validation_rules",                     comment: "Used for front end javascript validations."
    t.datetime "created_at",                           comment: "Date and time the record was created."
    t.datetime "updated_at",                           comment: "Date and time the record was last updated. "
    t.integer  "disqualifier_id",                      comment: "Foreign Key to the Disqualifier table."
    t.text     "repeater_label",                       comment: "Text to be displayed for repeating questions - see US1418"
    t.integer  "minimum",                              comment: "Minimum number of answers for the repeating question type"
    t.integer  "maximum",                              comment: "Maximum number of answers for the repeating question type "
  end

  add_index "question_presentations", ["deleted_at"], name: "index_question_presentations_on_deleted_at", using: :btree
  add_index "question_presentations", ["question_id", "section_id", "deleted_at"], name: "UK_presentation", unique: true, using: :btree
  add_index "question_presentations", ["question_id", "section_id", "deleted_at"], name: "index_question_pres_on_question_id_and_section_id", unique: true, using: :btree

  create_table "question_rules", force: :cascade, comment: "The question_rules table stores any logic needed for question logic." do |t|
    t.integer  "question_type_id",                 null: false, comment: "Foreign Key to the Questions Type table."
    t.integer  "capability",                       null: false, comment: "Controls if a comment or attachment is needed."
    t.boolean  "mandatory",        default: false, null: false, comment: "Determines if a comment or question is required."
    t.integer  "condition",        default: 0,     null: false, comment: "Used to determine the presentation of a comment or attachment."
    t.text     "value",                                         comment: "Controls the expected value to be presented."
    t.datetime "deleted_at",                                    comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                                    comment: "Date and time the record was created. "
    t.datetime "updated_at",                                    comment: "Date and time the record was last updated."
  end

  add_index "question_rules", ["deleted_at"], name: "index_question_rules_on_deleted_at", using: :btree
  add_index "question_rules", ["question_type_id", "capability", "mandatory", "condition", "value", "deleted_at"], name: "UK_question_rules", unique: true, using: :btree

  create_table "question_types", force: :cascade, comment: "The question_types is a grouping of question based on type." do |t|
    t.text     "name",           null: false, comment: "Name of question."
    t.text     "description",                 comment: "A description of the question types."
    t.datetime "deleted_at",                  comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                  comment: "Date and time the record was created. "
    t.datetime "updated_at",                  comment: "Date and time the record was last updated."
    t.text     "title",                       comment: "Title of question."
    t.text     "type",                        comment: "Type of question."
    t.json     "config_options",              comment: "Configuration options for the question type."
  end

  add_index "question_types", ["deleted_at"], name: "index_question_types_on_deleted_at", using: :btree
  add_index "question_types", ["name", "deleted_at"], name: "UK_question_type", unique: true, using: :btree
  add_index "question_types", ["name", "deleted_at"], name: "index_question_types_on_name_and_deleted_at", unique: true, using: :btree

  create_table "questionnaire_histories", force: :cascade, comment: "Used for questionnaire versioning" do |t|
    t.integer  "certificate_type_id",              comment: "Foreign Key to the Certificate Type table."
    t.integer  "questionnaire_id",                 comment: "Foreign Key to the Questionnaire table."
    t.string   "kind",                             comment: "The type of questionnaire"
    t.integer  "version",                          comment: "Version of the questionnaire"
    t.datetime "created_at",          null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",          null: false, comment: "Date and time the record was last updated."
  end

  add_index "questionnaire_histories", ["certificate_type_id"], name: "index_questionnaire_histories_on_certificate_type_id", using: :btree
  add_index "questionnaire_histories", ["questionnaire_id"], name: "index_questionnaire_histories_on_questionnaire_id", using: :btree

  create_table "questionnaires", force: :cascade, comment: "The questionnaires table stores questionnaire details." do |t|
    t.text     "name",                                         null: false, comment: "Name of questionnaire."
    t.text     "title",                                                     comment: "Title of questionnaire."
    t.text     "submit_text",               default: "Submit", null: false, comment: "Text for the submit button."
    t.boolean  "confirm",                   default: false,    null: false, comment: "Used to determine if the confirmation page should be displayed."
    t.boolean  "anonymous",                 default: false,    null: false, comment: "Identifies if the questionnaire is pre or post login."
    t.boolean  "determine_eligibility",     default: false,    null: false, comment: "Used to control display of all questions or eligibility."
    t.boolean  "display_title",             default: true,     null: false, comment: "Header for questionnaire."
    t.boolean  "single_page",               default: false,    null: false, comment: "Used to identify of the questionnaire is single page or not."
    t.datetime "deleted_at",                                                comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                                                comment: "Date and time the record was created. "
    t.datetime "updated_at",                                                comment: "Date and time the record was last updated."
    t.integer  "root_section_id",                                           comment: "Indicates the root section of the questionnaire."
    t.integer  "first_section_id",                                          comment: "Indicates the first section of the questionaire."
    t.integer  "program_id",                                                comment: "Foreign Key to the Programs table."
    t.integer  "maximum_allowed",           default: 1,                     comment: "same as in certificate type - moved here because there can be different types of questionnaires: initial, annual review, etc."
    t.integer  "certificate_type_id",                                       comment: "support for multiple questionnaires per cert type"
    t.boolean  "initial_app",                                               comment: "is this questionnaire used as the 'initial application' vendors fill out (with future support for multiple simultaneous)"
    t.boolean  "vendor_can_start",          default: true,                  comment: "Indicates if a vendor can start the questionnaire"
    t.boolean  "analyst_can_start",         default: false,                 comment: "Indicates if an analyst can start the questionnaire"
    t.string   "review_page_display_title",                                 comment: "The display title on the review page"
    t.string   "link_label",                                                comment: "The label used when linking to this questionnaire"
    t.string   "human_name",                                                comment: "The human name or short name used to refer to the questionnaire (EDWOSB, etc.)"
    t.string   "type",                                                      comment: "For subclassing questionnaires"
    t.boolean  "scheduler_can_start",       default: false
    t.integer  "prerequisite_order"
  end

  add_index "questionnaires", ["deleted_at"], name: "index_questionnaires_on_deleted_at", using: :btree
  add_index "questionnaires", ["name", "deleted_at"], name: "UK_questionnaires", unique: true, using: :btree
  add_index "questionnaires", ["program_id"], name: "index_qs_on_program_id", using: :btree

  create_table "questions", force: :cascade, comment: "The questions table stores all questions needed to be answered when attempting to become certified." do |t|
    t.text     "name",                              null: false, comment: "Name of question."
    t.text     "description",                                    comment: "A description of the questions."
    t.integer  "question_type_id",                  null: false, comment: "Foreign Key to the Questions Type table."
    t.datetime "deleted_at",                                     comment: "Date and time the record was soft deleted."
    t.text     "title",                                          comment: "\tTitle of question."
    t.boolean  "multi",             default: false,              comment: "Does this question have more than one answer?  An array of the same answer type"
    t.json     "helpful_info",                                   comment: "Where we stuff all the extra json details that we use for questions - mostly used for failure messages."
    t.json     "sub_questions",                                  comment: "For complex questions - like personal property, where there are a number of questions on the page with complex interdependencies, this field holds all the information for the subquestions, which is used to create 'virtual questions' in the application"
    t.json     "possible_values",                                comment: "For pick lists?  What is the list of possible values to choose from?"
    t.datetime "created_at",                                     comment: "Date and time the record was created."
    t.datetime "updated_at",                                     comment: "Date and time the record was last updated."
    t.text     "strategy",                                       comment: "What algorithm to use for calculating totals / massaging the final value that is stored for an answer."
    t.boolean  "prepopulate",       default: false,              comment: "Indicates if a questions can be prepopulated with the users' previous answer"
    t.string   "title_wrapper_tag",                              comment: "Adding the ability to wrap a question title with somthing other than h3"
  end

  add_index "questions", ["deleted_at"], name: "index_questions_on_deleted_at", using: :btree
  add_index "questions", ["name", "deleted_at"], name: "UK_question", unique: true, using: :btree
  add_index "questions", ["name", "deleted_at"], name: "index_questions_on_name_and_deleted_at", unique: true, using: :btree

  create_table "review_documents", force: :cascade, comment: "Mapping between a document and its associated review." do |t|
    t.integer  "review_id",                comment: "Foreign Key to the Reviews table."
    t.integer  "document_id",              comment: "Foreign Key to the Documents table."
    t.datetime "deleted_at",               comment: "Date and time the record was soft deleted."
    t.datetime "created_at",  null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",  null: false, comment: "Date and time the record was last updated."
  end

  add_index "review_documents", ["review_id", "document_id"], name: "index_review_documents_on_review_id_and_document_id", using: :btree

  create_table "reviews", force: :cascade, comment: "Used to track analyst reviews on sba applications and certifications" do |t|
    t.text     "type",                                                         comment: "sub class of review since we'll have different types of reviews which may eventually have their own workflows"
    t.text     "case_number",                                                  comment: "autogenerated unique identifier analysts can use to refer to a review, in the format of MZ12312341 (two letters followed by timestamp number)"
    t.integer  "sba_application_id",                                           comment: "Foreign Key to the SBA Applications table."
    t.integer  "certificate_id",                                               comment: "Foreign Key to the Certificates table."
    t.integer  "current_assignment_id",                                        comment: "Refers to the current owner / reviewer and surpervisor (analysts)"
    t.text     "workflow_state",                                               comment: "Used by the workflow gem to track the current state of the review"
    t.integer  "determination_id",                                             comment: "Foreign Key to the Determinations table."
    t.datetime "deleted_at",                                                   comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                                      null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",                                      null: false, comment: "Date and time the record was last updated."
    t.boolean  "workflow_dirty",                  default: false,              comment: "Attribute used to make the workflow gem work with Elasticsearch"
    t.date     "screening_due_date",                                           comment: "The due date for the screening"
    t.date     "processing_due_date",                                          comment: "When a review is due after application enters processing state"
    t.boolean  "recommend_eligible",                                           comment: "Boolean indicating if the review has been recommended to be eligible"
    t.boolean  "recommend_eligible_for_appeal",                                comment: "Boolean indicating if the review has been recommended to be eligible for appeal"
    t.boolean  "determine_eligible",                                           comment: "Boolean indicating if the review has been determined to be eligible"
    t.boolean  "determine_eligible_for_appeal",                                comment: "Boolean indicating if the review has been determined to be eligible for appeal"
    t.boolean  "processing_paused",               default: false,              comment: "flag that indicates if the review processing has been paused"
    t.date     "processing_pause_date",                                        comment: "The date that processing was paused"
    t.date     "letter_due_date",                                              comment: "Due date of the 15 day letter"
    t.datetime "reconsideration_or_appeal_clock",                              comment: "Date by which the user has to submit an appeal or reconsideration"
  end

  add_index "reviews", ["certificate_id", "deleted_at"], name: "index_reviews_on_cert_d", using: :btree
  add_index "reviews", ["current_assignment_id", "deleted_at"], name: "index_reviews_on_ca_d", using: :btree
  add_index "reviews", ["determination_id", "deleted_at"], name: "index_review_on_determ_d", using: :btree
  add_index "reviews", ["sba_application_id", "deleted_at"], name: "index_reviews_on_app_d", using: :btree

  create_table "roles", force: :cascade, comment: "The different roles that a user can be assigned. Used by system to authorize actions." do |t|
    t.text     "name",          null: false, comment: "Name of the role"
    t.integer  "resource_id",                comment: "The id of the model that a role is assigned to. Not used."
    t.text     "resource_type",              comment: "The model that a role is assigned to. Not used."
    t.datetime "deleted_at",                 comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                 comment: "Date and time the record was created."
    t.datetime "updated_at",                 comment: "Date and time the record was last updated."
  end

  add_index "roles", ["deleted_at"], name: "index_roles_on_deleted_at", using: :btree
  add_index "roles", ["name", "resource_type", "resource_id", "deleted_at"], name: "UK_Role", unique: true, using: :btree
  add_index "roles", ["name", "resource_type", "resource_id", "deleted_at"], name: "index_roles_on_name_and_resource_type_and_resource_id", unique: true, using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "sam_organizations", id: false, force: :cascade do |t|
    t.text     "duns"
    t.text     "duns_4"
    t.text     "cage_code"
    t.text     "dodaac"
    t.text     "sam_extract_code"
    t.text     "purpose_of_registration"
    t.text     "registration_date"
    t.text     "expiration_date"
    t.text     "last_update_date"
    t.text     "activation_date"
    t.text     "legal_business_name"
    t.text     "dba_name"
    t.text     "company_division"
    t.text     "division_number"
    t.text     "sam_address_1"
    t.text     "sam_address_2"
    t.text     "sam_city"
    t.text     "sam_province_or_state"
    t.text     "sam_zip_code_5"
    t.text     "sam_zip_code_4"
    t.text     "sam_country_code"
    t.text     "sam_congressional_district"
    t.text     "business_start_date"
    t.text     "fiscal_year_end_close_date"
    t.text     "company_security_level"
    t.text     "highest_employee_security_level"
    t.text     "corporate_url"
    t.text     "entity_structure"
    t.text     "state_of_incorporation"
    t.text     "country_of_incorporation"
    t.text     "business_type_counter"
    t.text     "bus_type_string"
    t.text     "agency_business_purpose"
    t.text     "primary_naics"
    t.text     "naics_code_counter"
    t.text     "naics_code_string"
    t.text     "psc_code_counter"
    t.text     "psc_code_string"
    t.text     "credit_card_usage"
    t.text     "correspondence_flag"
    t.text     "mailing_address_line_1"
    t.text     "mailing_address_line_2"
    t.text     "mailing_address_city"
    t.text     "mailing_address_zip_code_5"
    t.text     "mailing_address_zip_code_4"
    t.text     "mailing_address_country"
    t.text     "mailing_address_state_or_province"
    t.text     "govt_bus_poc_first_name"
    t.text     "govt_bus_poc_middle_initial"
    t.text     "govt_bus_poc_last_name"
    t.text     "govt_bus_poc_title"
    t.text     "govt_bus_poc_st_add_1"
    t.text     "govt_bus_poc_st_add_2"
    t.text     "govt_bus_poc_city"
    t.text     "govt_bus_poc_zip_code_5"
    t.text     "govt_bus_poc_zip_code_4"
    t.text     "govt_bus_poc_country_code"
    t.text     "govt_bus_poc_state_or_province"
    t.text     "govt_bus_poc_us_phone"
    t.text     "govt_bus_poc_us_phone_ext"
    t.text     "govt_bus_poc_non_us_phone"
    t.text     "govt_bus_poc_fax_us_only"
    t.text     "govt_bus_poc_email"
    t.text     "alt_govt_bus_poc_first_name"
    t.text     "alt_govt_bus_poc_middle_initial"
    t.text     "alt_govt_bus_poc_last_name"
    t.text     "alt_govt_bus_poc_title"
    t.text     "alt_govt_bus_poc_st_add_1"
    t.text     "alt_govt_bus_poc_st_add_2"
    t.text     "alt_govt_bus_poc_city"
    t.text     "alt_govt_bus_poc_zip_code_5"
    t.text     "alt_govt_bus_poc_zip_code_4"
    t.text     "alt_govt_bus_poc_country_code"
    t.text     "alt_govt_bus_poc_state_or_province"
    t.text     "alt_govt_bus_poc_us_phone"
    t.text     "alt_govt_bus_poc_us_phone_ext"
    t.text     "alt_govt_bus_poc_non_us_phone"
    t.text     "alt_govt_bus_poc_fax_us_only"
    t.text     "alt_govt_bus_poc_email"
    t.text     "past_perf_poc_poc_first_name"
    t.text     "past_perf_poc_poc_middle_initial"
    t.text     "past_perf_poc_poc_last_name"
    t.text     "past_perf_poc_poc_title"
    t.text     "past_perf_poc_st_add_1"
    t.text     "past_perf_poc_st_add_2"
    t.text     "past_perf_poc_city"
    t.text     "past_perf_poc_code"
    t.text     "past_perf_poc_zip_code_4"
    t.text     "past_perf_poc_country_code"
    t.text     "past_perf_poc_state_or_province"
    t.text     "past_perf_poc_us_phone"
    t.text     "past_perf_poc_us_phone_ext"
    t.text     "past_perf_poc_non_us_phone"
    t.text     "past_perf_poc_fax_us_only"
    t.text     "past_perf_poc_email"
    t.text     "alt_past_perf_poc_first_name"
    t.text     "alt_past_perf_poc_middle_initial"
    t.text     "alt_past_perf_poc_last_name"
    t.text     "alt_past_perf_poc_title"
    t.text     "alt_past_perf_poc_st_add_1"
    t.text     "alt_past_perf_poc_st_add_2"
    t.text     "alt_past_perf_poc_city"
    t.text     "alt_past_perf_poc_code"
    t.text     "alt_past_perf_poc_zip_code_4"
    t.text     "alt_past_perf_poc_country_code"
    t.text     "alt_past_perf_poc_state_or_province"
    t.text     "alt_past_perf_poc_us_phone"
    t.text     "alt_past_perf_poc_us_phone_ext"
    t.text     "alt_past_perf_poc_non_us_phone"
    t.text     "alt_past_perf_poc_fax_us_only"
    t.text     "alt_past_perf_poc_email"
    t.text     "elec_bus_poc_first_name"
    t.text     "elec_bus_poc_middle_initial"
    t.text     "elec_bus_poc_last_name"
    t.text     "elec_bus_poc_title"
    t.text     "elec_bus_poc_st_add_1"
    t.text     "elec_bus_poc_st_add_2"
    t.text     "elec_bus_poc_city"
    t.text     "elec_bus_poc_zip_code_5"
    t.text     "elec_bus_poc_zip_code_4"
    t.text     "elec_bus_poc_country_code"
    t.text     "elec_bus_poc_state_or_province"
    t.text     "elec_bus_poc_us_phone"
    t.text     "elec_bus_poc_us_phone_ext"
    t.text     "elec_bus_poc_non_us_phone"
    t.text     "elec_bus_poc_fax_us_only"
    t.text     "elec_bus_poc_email"
    t.text     "alt_elec_poc_bus_poc_first_name"
    t.text     "alt_elec_poc_bus_poc_middle_initial"
    t.text     "alt_elec_poc_bus_poc_last_name"
    t.text     "alt_elec_poc_bus_poc_title"
    t.text     "alt_elec_poc_bus_st_add_1"
    t.text     "alt_elec_poc_bus_st_add_2"
    t.text     "alt_elec_poc_bus_city"
    t.text     "alt_elec_poc_bus_zip_code_5"
    t.text     "alt_elec_poc_bus_zip_code_4"
    t.text     "alt_elec_poc_bus_country_code"
    t.text     "alt_elec_poc_bus_state_or_province"
    t.text     "alt_elec_poc_bus_us_phone"
    t.text     "alt_elec_poc_bus_us_phone_ext"
    t.text     "alt_elec_poc_bus_non_us_phone"
    t.text     "alt_elec_poc_bus_fax_us_only"
    t.text     "alt_elec_poc_bus_email"
    t.text     "party_performing_certification_poc_first_name"
    t.text     "party_performing_certification_poc_middle_initial"
    t.text     "party_performing_certification_poc_last_name"
    t.text     "party_performing_certification_poc_title"
    t.text     "party_performing_certification_poc_bus_st_add_1"
    t.text     "party_performing_certification_poc_bus_st_add_2"
    t.text     "party_performing_certification_poc_bus_city"
    t.text     "party_performing_certification_poc_bus_zip_code_5"
    t.text     "party_performing_certification_poc_bus_zip_code_4"
    t.text     "party_performing_certification_poc_bus_country_code"
    t.text     "party_performing_certification_poc_bus_state_or_province"
    t.text     "party_performing_certification_poc_us_phone"
    t.text     "party_performing_certification_poc_us_phone_ext"
    t.text     "party_performing_certification_poc_non_us_phone"
    t.text     "party_performing_certification_poc_fax_us_only"
    t.text     "party_performing_certification_poc_email"
    t.text     "sole_proprietorship_poc_first_name"
    t.text     "sole_proprietorship_poc_middle_initial"
    t.text     "sole_proprietorship_poc_last_name"
    t.text     "sole_proprietorship_poc_title"
    t.text     "sole_proprietorship_poc_us_phone"
    t.text     "sole_proprietorship_poc_us_phone_ext"
    t.text     "sole_proprietorship_poc_non_us_phone"
    t.text     "sole_proprietorship_poc_fax_us_only"
    t.text     "sole_proprietorship_poc_email"
    t.text     "headquarter_parent_poc_(hq)"
    t.text     "hq_parent_duns_number"
    t.text     "hq_parent_st_add_1"
    t.text     "hq_parent_st_add_2"
    t.text     "hq_parent_city"
    t.text     "hq_parent_postal_code"
    t.text     "hq_parent_country_code"
    t.text     "hq_parent_state_or_province"
    t.text     "hq_parent_phone"
    t.text     "domestic_parent_poc_(dm)"
    t.text     "domestic_parent_duns_number"
    t.text     "domestic_parent_st_add_1"
    t.text     "domestic_parent_st_add_2"
    t.text     "domestic_parent_city"
    t.text     "domestic_parent_postal_code"
    t.text     "domestic_parent_country_code"
    t.text     "domestic_parent_state_or_province"
    t.text     "domestic_parent_phone"
    t.text     "global_parent_poc_(gl)"
    t.text     "global_parent_duns_number"
    t.text     "global_parent_st_add_1"
    t.text     "global_parent_st_add_2"
    t.text     "global_parent_city"
    t.text     "global_parent_postal_code"
    t.text     "global_parent_country_code"
    t.text     "global_parent_state_or_province"
    t.text     "global_parent_phone"
    t.text     "dnb_out_of_business_indicator"
    t.text     "dnb_monitoring_last_updated"
    t.text     "dnb_monitoring_status"
    t.text     "dnb_monitoring_legal_business_name"
    t.text     "dnb_monitoring_dba"
    t.text     "dnb_monitoring_address_1"
    t.text     "dnb_monitoring_address_2"
    t.text     "dnb_monitoring_city"
    t.text     "dnb_monitoring_postal_code"
    t.text     "dnb_monitoring_country_code"
    t.text     "dnb_monitoring_state_or_province"
    t.text     "edi"
    t.text     "edi_van_provider"
    t.text     "isa_qualifier"
    t.text     "isa_identifier"
    t.text     "functional_group_identifier"
    t.text     "820s_request_flag"
    t.text     "edi_poc_first_name"
    t.text     "edi_poc_middle_initial"
    t.text     "edi_poc_last_name"
    t.text     "edi_poc_title"
    t.text     "edi_poc_us_phone"
    t.text     "edi_poc_us_phone_ext"
    t.text     "edi_poc_non_us_phone"
    t.text     "edi_poc_fax_us_only"
    t.text     "edi_poc_email"
    t.text     "tax_identifier_type"
    t.text     "tax_identifier_number"
    t.text     "average_number_of_employees"
    t.text     "average_annual_revenue"
    t.text     "financial_institute"
    t.text     "account_number"
    t.text     "aba_routing_id"
    t.text     "account_type"
    t.text     "lockbox_number"
    t.text     "authorization_date"
    t.text     "eft_waiver"
    t.text     "ach_us_phone"
    t.text     "ach_non_us_phone"
    t.text     "ach_fax"
    t.text     "ach_email"
    t.text     "remittance_name"
    t.text     "remittance_address_line_1"
    t.text     "remittance_address_line_2"
    t.text     "remittance_city"
    t.text     "remittance_state_or_province"
    t.text     "remittance_zip_code_5"
    t.text     "remittance_zip_code_4"
    t.text     "remittance_country"
    t.text     "accounts_receivable_poc_first_name"
    t.text     "accounts_receivable_poc_middle_initial"
    t.text     "accounts_receivable_poc_last_name"
    t.text     "accounts_receivable_poc_title"
    t.text     "accounts_receivable_poc_us_phone"
    t.text     "accounts_receivable_poc_us_phone_ext"
    t.text     "accounts_receivable_poc_non_us_phone"
    t.text     "accounts_receivable_poc_fax_us_only"
    t.text     "accounts_receivable_poc_email"
    t.text     "accounts_payable_poc_first_name"
    t.text     "accounts_payable_poc_middle_initial"
    t.text     "accounts_payable_poc_last_name"
    t.text     "accounts_payable_poc_title"
    t.text     "accounts_payable_poc_st_add_1"
    t.text     "accounts_payable_poc_st_add_2"
    t.text     "accounts_payable_poc_city"
    t.text     "accounts_payable_poc_zip_code_5"
    t.text     "accounts_payable_poc_zip_code_4"
    t.text     "accounts_payable_poc_country_code"
    t.text     "accounts_payable_poc_state_or_province"
    t.text     "accounts_payable_poc_us_phone"
    t.text     "accounts_payable_poc_us_phone_ext"
    t.text     "accounts_payable_poc_non_us_phone"
    t.text     "accounts_payable_poc_fax_us_only"
    t.text     "accounts_payable_poc_email"
    t.text     "mpin"
    t.text     "naics_exception_counter"
    t.text     "naics_exception_string"
    t.text     "delinquent_federal_debt_flag"
    t.text     "exclusion_status_flag"
    t.text     "sba_business_types_counter"
    t.text     "sba_business_types_string"
    t.text     "sam_numerics_counter"
    t.text     "sam_numerics_code_string"
    t.text     "no_public_display_flag"
    t.text     "disaster_response_counter"
    t.text     "disaster_response_string"
    t.text     "annual_igt_revenue"
    t.text     "agency_location_code"
    t.text     "disbursing_office_symbol"
    t.text     "merchant_id_1"
    t.text     "merchant_id_2"
    t.text     "accounting_station"
    t.text     "source"
    t.text     "department_code"
    t.text     "hierarchy_department_code"
    t.text     "hierarchy_department_name"
    t.text     "hierarchy_agency_code"
    t.text     "hierarchy_agency_name"
    t.text     "hierarchy_office_code"
    t.text     "eliminations_poc_first_name"
    t.text     "eliminations_poc_middle_initial"
    t.text     "eliminations_poc_last_name"
    t.text     "eliminations_poc_title"
    t.text     "eliminations_poc_st_add_1"
    t.text     "eliminations_poc_st_add_2"
    t.text     "eliminations_poc_city"
    t.text     "eliminations_poc_zip_code_5"
    t.text     "eliminations_poc_zip_code_4"
    t.text     "eliminations_poc_country_code"
    t.text     "eliminations_poc_state_or_province"
    t.text     "eliminations_poc_us_phone"
    t.text     "eliminations_poc_us_phone_ext"
    t.text     "eliminations_poc_non_us_phone"
    t.text     "eliminations_poc_fax_us_only"
    t.text     "eliminations_poc_email"
    t.text     "sales_poc_first_name"
    t.text     "sales_poc_middle_initial"
    t.text     "sales_poc_last_name"
    t.text     "sales_poc_title"
    t.text     "sales_poc_st_add_1"
    t.text     "sales_poc_st_add_2"
    t.text     "sales_poc_city"
    t.text     "sales_poc_zip_code_5"
    t.text     "sales_poc_zip_code_4"
    t.text     "sales_poc_country_code"
    t.text     "sales_poc_state_or_province"
    t.text     "sales_poc_us_phone"
    t.text     "sales_poc_us_phone_ext"
    t.text     "sales_poc_non_us_phone"
    t.text     "sales_poc_fax_us_only"
    t.text     "sales_poc_email"
    t.datetime "record_create_dt"
    t.datetime "record_update_dt"
  end

  create_table "sba_application_documents", force: :cascade, comment: "Mapping between a document and its associated application." do |t|
    t.integer  "sba_application_id", null: false, comment: "\tForeign Key to the SBA Applications table."
    t.integer  "document_id",        null: false, comment: "\tForeign Key to the Documents table."
    t.datetime "deleted_at",                      comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                      comment: "Date and time the record was created."
    t.datetime "updated_at",                      comment: "Date and time the record was last updated."
  end

  add_index "sba_application_documents", ["document_id", "sba_application_id", "deleted_at"], name: "UK_sba_application_documents", unique: true, using: :btree
  add_index "sba_application_documents", ["document_id", "sba_application_id", "deleted_at"], name: "index_sba_application_documents_on_sba_application_id", using: :btree

  create_table "sba_applications", force: :cascade, comment: "The sba_applications table stores all certification applications submitted to the SBA." do |t|
    t.integer  "application_status_type_id",                               comment: "\tForeign Key to the Application Status Type table."
    t.integer  "organization_id",                             null: false, comment: "Foreign Key to the Organizations table."
    t.datetime "application_start_date",                      null: false, comment: "Date and time of when the application was started."
    t.datetime "deleted_at",                                               comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                                               comment: "Date and time the record was created. "
    t.datetime "updated_at",                                               comment: "Date and time the record was last updated. "
    t.json     "progress",                                                 comment: "Measures progress of the application."
    t.json     "signature",                                                comment: "Holds the signature from the application. This is from the signature section which is not stored as Answers"
    t.datetime "application_submitted_at",                                 comment: "Timestamp of when the application was submitted"
    t.integer  "root_section_id",                                          comment: "Indicates the root section of the application."
    t.integer  "first_section_id",                                         comment: "Indicates the first section of the application."
    t.boolean  "renewal",                     default: false,              comment: "Indicates if application is a renewals of an initial application"
    t.text     "workflow_state",                                           comment: "Used by the workflow gem to track the current state of the application"
    t.integer  "version_number",                                           comment: "Sequential version to be displayed in the UI"
    t.integer  "current_sba_application_id",                               comment: "The id of the master application this version is associated with"
    t.boolean  "is_current",                                               comment: "Boolean indicating if this application is the current one."
    t.json     "sam_snapshot",                                             comment: "JSON with most current SAM data for the organization associated with this application"
    t.integer  "certificate_id",                                           comment: "Foreign Key to the Certificate table."
    t.integer  "questionnaire_id",                                         comment: "each app needs to associate directly to a questionnaire instead of a cert type"
    t.string   "type",                                                     comment: "For subclassing applications"
    t.integer  "master_application_id",                                    comment: "The id of the master application this sub-application is associated with"
    t.integer  "position",                                                 comment: "The order in which the application was created."
    t.string   "kind",                                                     comment: "The type of SBA Application. Possible values include initial, annual_review, adhoc, reconsideration, info_request or entity_owned_initial"
    t.integer  "current_section_id",                                       comment: "Used to track the current section for sub applications so you can quickly get back to that section from the master app"
    t.integer  "zip_file_status",             default: 0,                  comment: "Status of Zip file of all documents. 0 - Not Created, 1 - Pending, 2 - Ready. Refer story APP-473"
    t.integer  "prerequisite_order"
    t.boolean  "workflow_dirty",              default: false,              comment: "Attribute used to make the workflow gem work with Elasticsearch"
    t.integer  "returned_by",                                              comment: "Track the last case owner who returned this application to vendor"
    t.integer  "original_certificate_id",                                  comment: "HIS COLUMN IS NEEDED IN THE INTERIM TO TIE ANNUAL RENEWAL (ANNUAL REPORT) CERTS TO THE ORIGINAL CERTIFICATE THAT WAS CREATED FOR THEM"
    t.text     "adhoc_question_title",                                     comment: "The question title of the adhoc questionnaire"
    t.text     "adhoc_question_details",                                   comment: "The question detail of the adhoc questionnaire"
    t.date     "screening_due_date",                                       comment: "The due date for the screening"
    t.integer  "returned_reviewer_id"
    t.integer  "creator_id",                                               comment: "User id of the person that created the application"
    t.integer  "unanswered_adhoc_reviews",    default: 0,                  comment: "The count of unanswered adhoc reviews"
    t.string   "bdmis_case_number",                                        comment: "The BDMIS case number"
    t.date     "review_for",                                               comment: "The date the annual review is set for."
    t.integer  "review_number",                                            comment: "The number of the review, 1 thru 8."
    t.integer  "info_request_assigned_to_id",                              comment: "The id of the user who's workload queue this application (request for info) will show up in"
  end

  add_index "sba_applications", ["deleted_at"], name: "index_sba_applications_on_deleted_at", using: :btree
  add_index "sba_applications", ["questionnaire_id", "organization_id", "application_start_date", "deleted_at"], name: "UK_sba_application", unique: true, using: :btree

  create_table "section_rules", force: :cascade, comment: "The section_rules table stores all the logic for each section." do |t|
    t.integer  "questionnaire_id",                       null: false, comment: "Foreign Key to the Questionnaires table."
    t.integer  "from_section_id",                                     comment: "Controls which section to move backwards to."
    t.integer  "to_section_id",                                       comment: "Controls which section to move forward to."
    t.datetime "deleted_at",                                          comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                                          comment: "Date and time the record was created."
    t.datetime "updated_at",                                          comment: "Date and time the record was last updated."
    t.json     "skip_info",                                           comment: "Controls any sections that are NA."
    t.json     "expression",                                          comment: "Expression to check if this rule applies to current state."
    t.integer  "sba_application_id",                                  comment: "Foreign Key to the SBA Applications table."
    t.integer  "template_root_id",                                    comment: "If this section rule relates to a template section, what is the root of the template tree."
    t.boolean  "dynamic",                default: false, null: false, comment: "Is this section rule for a dynamic section (created from Form 413)."
    t.boolean  "is_last",                default: false, null: false, comment: "Is this the last rule?  - used to determine when to continue to the regular section rules after handling dynamic sections."
    t.boolean  "is_multi_path_template", default: false,              comment: "Determines if this rule contain a multi-path question that enables / disables other sections"
    t.integer  "terminal_section_id",                                 comment: "The next section to go to after the potential sections that are enabled by the multi-path rule"
    t.integer  "generated_from_id",                                   comment: "For dynamically created section rules (from multi path questions), this points to the original section_rule that created the section"
  end

  add_index "section_rules", ["deleted_at"], name: "index_section_rules_on_deleted_at", using: :btree
  add_index "section_rules", ["sba_application_id", "questionnaire_id", "from_section_id", "to_section_id", "deleted_at"], name: "section_rules_ukey", unique: true, using: :btree

  create_table "sections", force: :cascade, comment: "The sections table store each section of an application." do |t|
    t.text     "name",                                            null: false, comment: "Name of section."
    t.text     "description",                                                  comment: "A description of the sections."
    t.integer  "sba_application_id",                                           comment: "Foreign Key to the SBA Applications table."
    t.text     "ancestry",                                                     comment: "This records the parents of this section."
    t.datetime "deleted_at",                                                   comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                                                   comment: "Date and time the record was created. "
    t.datetime "updated_at",                                                   comment: "Date and time the record was last updated."
    t.text     "title",                                                        comment: "Title of the section."
    t.text     "submit_text",                default: "Continue", null: false, comment: "Text that should appear on the Submit button on the page."
    t.integer  "questionnaire_id",                                null: false, comment: "Foreign Key to the Questionnaires table."
    t.text     "type",                                                         comment: "Type of section."
    t.integer  "template_id",                                                  comment: "For dynamic sections (Form 413) this references the original template that was used to create the section"
    t.json     "repeat",                                                       comment: "Is this a repeating section (Form 413) where you can have a list of the same section (one for each business partner)"
    t.boolean  "displayable",                default: true,                    comment: "Template sections are not displayed in the UI - just used for creating other sections - so they're not displable"
    t.integer  "position",                                                     comment: "Order the section is displayed in the tree."
    t.integer  "answered_for_id",                                              comment: "For dynamic sections, the model id (business partner id) that this section is associated with."
    t.text     "answered_for_type",                                            comment: "For dynamic sections, the model type (BusinessPartner)."
    t.integer  "original_section_id",                                          comment: "When an application is created the sections are copied from the questionnaire - so each application has it's own hierarchy.  The original section refers to the section in the questionnaire.that corresponds to this section. Used to proxy the questions / question presentations"
    t.boolean  "dynamic",                    default: false,                   comment: "Is this a dynamic section that was created from a template?"
    t.text     "template_type",                                                comment: "What is the subtype of the template, so you can dynamically create different types of sections (question section, review section, etc)."
    t.json     "validation_rules",                                             comment: "Used for front end javascript validations."
    t.boolean  "is_applicable",              default: true,                    comment: "Indicates if the section is applicable based on previous responses."
    t.boolean  "is_completed",               default: false,      null: false, comment: "Indicates if the section is completed based on responses."
    t.integer  "review_position",                                              comment: "Added to make it easier to present the question review page with properly ordered sections and questions to analysts"
    t.boolean  "sub_sections_completed",     default: false,                   comment: "Used to determine whether to show a green checkmark in the questionnaire side nav"
    t.boolean  "sub_sections_applicable",    default: true,                    comment: "Used to determine whether to gray out the section in the questionnaire side nav"
    t.integer  "defer_applicability_for_id",                                   comment: "Multi-path sections need to be skipped when going to the review section, this is how we know what they are"
    t.integer  "sub_questionnaire_id",                                         comment: "For master questionnaires to have sub questionnaires"
    t.integer  "sub_application_id",                                           comment: "For master applications to have sub applicationss"
    t.string   "status",                                                       comment: "Used for sub applications to determine if the app has been started, is in progress or has been completed"
    t.boolean  "prescreening",               default: false,                   comment: "This will be used for any sub-sections / sub applications that are to be completed BEFORE reaching the master 8a questionnaire"
    t.boolean  "is_last",                    default: false,                   comment: "Used to determine which page to use to submit the application (sub apps submit from review, where others submit from signature)"
    t.integer  "related_to_section_id",                                        comment: "for adhoc questionnaires - they are related to other subsections in the application"
  end

  add_index "sections", ["ancestry"], name: "index_sections_on_ancestry", using: :btree
  add_index "sections", ["name", "questionnaire_id", "sba_application_id", "deleted_at"], name: "UK_grouping_purpose", unique: true, using: :btree
  add_index "sections", ["name", "questionnaire_id", "sba_application_id", "deleted_at"], name: "index_sections_on_name_sba_app_and_deleted", unique: true, using: :btree
  add_index "sections", ["questionnaire_id"], name: "index_sections_on_questionnaire_id", using: :btree
  add_index "sections", ["sba_application_id"], name: "index_sections_on_sba_application_id", using: :btree
  add_index "sections", ["sub_application_id"], name: "index_sections_on_sub_application_id", using: :btree

  create_table "sessions", force: :cascade, comment: "The sessions table holds an entry for each user session opened. If closed correctly the entry is removed." do |t|
    t.text     "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "tags", force: :cascade, comment: "Tags that are associated to SBA notes that analysts create. Used for filtering." do |t|
    t.text     "name",       null: false, comment: "name of the tag"
    t.datetime "deleted_at",              comment: "Date and time the record was soft deleted."
    t.datetime "created_at",              comment: "Date and time the record was created."
    t.datetime "updated_at",              comment: "Date and time the record was last updated."
  end

  add_index "tags", ["deleted_at"], name: "index_tags_on_deleted_at", using: :btree

  create_table "users", force: :cascade, comment: "The users table stores all users that login to the system." do |t|
    t.text     "email",                                null: false, comment: "Email address of the user."
    t.datetime "deleted_at",                                        comment: "Date and time the record was soft deleted."
    t.datetime "created_at",                                        comment: "Date and time the record was created."
    t.datetime "updated_at",                                        comment: "Date and time the record was last updated. "
    t.text     "encrypted_password",      default: "", null: false, comment: "Password salted and encrypted. Uses bcrypt algorithm"
    t.text     "reset_password_token",                              comment: "Unique token generated when user requests for a password reset"
    t.datetime "reset_password_sent_at",                            comment: "Timestamp of when the reset password request was initiated"
    t.integer  "sign_in_count",           default: 0,  null: false, comment: "Number of successful Sign Ins the user has had to the system"
    t.datetime "current_sign_in_at",                                comment: "When the user currently signed in."
    t.datetime "last_sign_in_at",                                   comment: "The last time the user signed in"
    t.inet     "current_sign_in_ip",                                comment: "IP address of the current sign in"
    t.inet     "last_sign_in_ip",                                   comment: "IP address of the last sign in"
    t.text     "confirmation_token",                                comment: "Unique token generated when the user signs up and is sent an email to confirm account."
    t.datetime "confirmed_at",                                      comment: "Timestamp of when the account was confirmed."
    t.datetime "confirmation_sent_at",                              comment: "Timestamp of when the confirmation email was sent."
    t.text     "unconfirmed_email",                                 comment: "NOT USED"
    t.integer  "failed_attempts",         default: 0,  null: false, comment: "Number of failed sign in attempts the user has had"
    t.text     "unlock_token",                                      comment: "Unique token generated when the user requests to unlock account. "
    t.datetime "locked_at",                                         comment: "Timestamp of when the account was locked"
    t.text     "first_name",                                        comment: "User's first name."
    t.text     "last_name",                                         comment: "User's last name."
    t.text     "phone_number",                                      comment: "User's phone number."
    t.string   "provider",                                          comment: "authentication provider"
    t.string   "uid",                                               comment: "id of the authentication provider"
    t.string   "max_user_classification",                           comment: "MAX.gov clasification ( federal or contractor )"
    t.string   "max_agency",                                        comment: "User's agency within MAX.gov ( Small Buisness Adminstration )"
    t.string   "max_org_tag",                                       comment: "User's agency tag name (abreviation ex SBA) in MAX.gov"
    t.string   "max_group_list",                                    comment: "User's groups within MAX.gov"
    t.string   "max_id",                                            comment: "User's MAX.gov ID which is *-> Max primary key <-*"
    t.string   "max_first_name",                                    comment: "User's first name in MAX.gov"
    t.string   "max_security_level_list",                           comment: "User's security level in MAX.gov"
    t.string   "max_last_name",                                     comment: "User's last name in MAX.gov"
    t.string   "max_email",                                         comment: "User's email in MAX.gov"
    t.string   "max_bureau",                                        comment: "User's bureau within an organization saved in MAX.gov"
    t.json     "roles_map",                                         comment: "this is the user hash where the roles will be saved"
    t.uuid     "uuid",                                              comment: "A better unique id for the user"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email", "deleted_at"], name: "UK_authenticated_user", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade, comment: "The users _roles table stores the roles of the users." do |t|
    t.integer  "user_id",    null: false
    t.integer  "role_id",    null: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_roles", ["deleted_at"], name: "index_users_roles_on_deleted_at", using: :btree
  add_index "users_roles", ["user_id", "role_id", "deleted_at"], name: "UK_users_roles", unique: true, using: :btree
  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.text     "item_type",      null: false
    t.integer  "item_id",        null: false
    t.text     "event",          null: false
    t.text     "whodunnit"
    t.jsonb    "object"
    t.jsonb    "object_changes"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "voluntary_suspensions", force: :cascade do |t|
    t.string   "option"
    t.string   "title"
    t.text     "body"
    t.integer  "status",                               default: 0
    t.string   "document"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "organization_id"
    t.integer  "certificate_id"
    t.datetime "extended_at"
    t.integer  "extended_by_id"
    t.datetime "denied_at"
    t.integer  "denied_by_id"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size",         limit: 8
    t.datetime "document_updated_at"
    t.integer  "suspension_duration_months"
  end

  create_table "workflow_changes", force: :cascade, comment: "Table used to track all state changes for models that use the workflow gem" do |t|
    t.text     "model_type",                  comment: "The model class"
    t.integer  "model_id",                    comment: "The model primary key"
    t.text     "workflow_state",              comment: "The state of the model"
    t.integer  "user_id",                     comment: "Foreign Key to the Users table. (apparently not used)"
    t.datetime "deleted_at",                  comment: "Date and time the record was soft deleted."
    t.datetime "created_at",     null: false, comment: "Date and time the record was created."
    t.datetime "updated_at",     null: false, comment: "Date and time the record was last updated."
  end

  add_index "workflow_changes", ["model_type", "model_id", "deleted_at"], name: "index_assignments_on_model_d", using: :btree
  add_index "workflow_changes", ["user_id", "deleted_at"], name: "index_assignments_on_user_d", using: :btree

  add_foreign_key "agency_requirement_organizations", "agency_requirements"
  add_foreign_key "agency_requirement_organizations", "organizations"
  add_foreign_key "agency_requirements", "agency_contract_types"
  add_foreign_key "agency_requirements", "agency_cos"
  add_foreign_key "agency_requirements", "agency_naics_codes"
  add_foreign_key "agency_requirements", "agency_offer_agreements"
  add_foreign_key "agency_requirements", "agency_offer_codes"
  add_foreign_key "agency_requirements", "agency_offer_scopes"
  add_foreign_key "agency_requirements", "agency_offices"
  add_foreign_key "agency_requirements", "duty_stations"
  add_foreign_key "agency_requirements", "programs"
  add_foreign_key "agency_requirements", "users"
  add_foreign_key "answer_documents", "answers"
  add_foreign_key "answer_documents", "documents"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "sba_applications"
  add_foreign_key "applicable_questions", "evaluation_purposes"
  add_foreign_key "applicable_questions", "questions"
  add_foreign_key "application_status_histories", "application_status_types"
  add_foreign_key "application_status_histories", "sba_applications"
  add_foreign_key "assessments", "notes"
  add_foreign_key "assessments", "reviews"
  add_foreign_key "assignments", "reviews"
  add_foreign_key "assignments", "users", column: "owner_id"
  add_foreign_key "assignments", "users", column: "reviewer_id"
  add_foreign_key "assignments", "users", column: "supervisor_id"
  add_foreign_key "bdmis_migrations", "sba_applications"
  add_foreign_key "business_partners", "sba_applications"
  add_foreign_key "certificate_status_histories", "certificate_status_types"
  add_foreign_key "certificate_status_histories", "certificates"
  add_foreign_key "certificates", "certificate_status_types"
  add_foreign_key "certificates", "certificate_types"
  add_foreign_key "certificates", "organizations"
  add_foreign_key "current_questionnaires", "certificate_types"
  add_foreign_key "current_questionnaires", "questionnaires"
  add_foreign_key "determinations", "users", column: "decider_id"
  add_foreign_key "document_type_questions", "document_types"
  add_foreign_key "document_type_questions", "questions"
  add_foreign_key "documents", "document_types"
  add_foreign_key "documents", "organizations"
  add_foreign_key "eligibility_results", "evaluation_purposes"
  add_foreign_key "eligible_naic_codes", "certificate_types"
  add_foreign_key "evaluation_histories", "sba_applications", column: "evaluable_id"
  add_foreign_key "evaluation_purposes", "certificate_types"
  add_foreign_key "evaluation_purposes", "questionnaires"
  add_foreign_key "groups", "programs"
  add_foreign_key "notes", "users", column: "author_id"
  add_foreign_key "question_presentations", "disqualifiers"
  add_foreign_key "question_presentations", "questions"
  add_foreign_key "question_presentations", "sections"
  add_foreign_key "question_rules", "question_types"
  add_foreign_key "questionnaire_histories", "certificate_types"
  add_foreign_key "questionnaire_histories", "questionnaires"
  add_foreign_key "questionnaires", "programs"
  add_foreign_key "questions", "question_types"
  add_foreign_key "reviews", "assignments", column: "current_assignment_id"
  add_foreign_key "reviews", "certificates"
  add_foreign_key "reviews", "determinations"
  add_foreign_key "reviews", "sba_applications"
  add_foreign_key "sba_application_documents", "documents"
  add_foreign_key "sba_application_documents", "sba_applications"
  add_foreign_key "sba_applications", "application_status_types"
  add_foreign_key "sba_applications", "organizations"
  add_foreign_key "section_rules", "questionnaires"
  add_foreign_key "section_rules", "sba_applications"
  add_foreign_key "sections", "questionnaires"
  add_foreign_key "sections", "sba_applications"
  add_foreign_key "users_roles", "roles"
  add_foreign_key "users_roles", "users"
  add_foreign_key "voluntary_suspensions", "certificates"
  add_foreign_key "voluntary_suspensions", "organizations"
  add_foreign_key "voluntary_suspensions", "users", column: "denied_by_id"
  add_foreign_key "voluntary_suspensions", "users", column: "extended_by_id"
  add_foreign_key "workflow_changes", "users"
end
