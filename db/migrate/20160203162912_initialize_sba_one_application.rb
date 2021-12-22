class InitializeSbaOneApplication < ActiveRecord::Migration
  def change

    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"

    create_table "anonymous_users", force: :cascade do |t|
      t.datetime "deleted_at"
      t.timestamps
    end

    add_index "anonymous_users", ["deleted_at"], name: "index_anonymous_users_on_deleted_at", using: :btree

    create_table "answer_documents", force: :cascade do |t|
      t.integer  "answer_id", null: false
      t.integer  "document_id", null: false
      t.datetime "deleted_at"
      t.timestamps
    end

    add_index "answer_documents", ["answer_id", "document_id", "deleted_at"], name: "answer_doc_answer_id_doc_id", unique: true, using: :btree
    add_index "answer_documents", ["deleted_at"], name: "index_answer_documents_on_deleted_at", using: :btree

    create_table "answers", force: :cascade do |t|
      t.text     "type"
      t.integer  "owner_id"
      t.text     "owner_type"
      t.integer  "sba_application_id"
      t.integer  "question_id", null: false
      t.text     "evaluated_response"
      t.text     "response"
      t.text     "comment"
      t.datetime "deleted_at"
      t.timestamps
      t.json     "value"
      t.json     "details"
      t.integer  "answered_for_id"
      t.text     "answered_for_type"
    end

    add_index "answers", ["deleted_at"], name: "index_answers_on_deleted_at", using: :btree
    add_index "answers", ["owner_type", "owner_id"], name: "index_answers_on_owner_type_and_owner_id", using: :btree
    add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
    add_index "answers", ["sba_application_id", "owner_type", "owner_id", "answered_for_type", "answered_for_id", "question_id", "deleted_at"], name: "i_answers_on_owner_quest_answered4", unique: true, using: :btree

    create_table "applicable_questions", force: :cascade do |t|
      t.integer  "evaluation_purpose_id", null: false
      t.integer  "question_id", null: false
      t.text     "positive_response"
      t.json     "lookup"
      t.datetime "deleted_at"
      t.timestamps
    end

    add_index "applicable_questions", ["deleted_at"], name: "index_applicable_questions_on_deleted_at", using: :btree
    add_index "applicable_questions", ["evaluation_purpose_id", "question_id", "deleted_at"], name: "app_quest_eval_purp_quest_idx", unique: true, using: :btree

    create_table "application_status_histories", force: :cascade do |t|
      t.integer  "sba_application_id", null: false
      t.integer  "application_status_type_id", null: false
      t.datetime "status_reached_at",          null: false
      t.datetime "deleted_at"
      t.timestamps
    end

    add_index "application_status_histories", ["deleted_at"], name: "index_application_status_histories_on_deleted_at", using: :btree
    add_index "application_status_histories", ["sba_application_id", "application_status_type_id", "deleted_at"], name: "index_app_status_id", unique: true, using: :btree

    create_table "application_status_types", force: :cascade do |t|
      t.text   "name",        null: false
      t.text   "description", null: false
      t.datetime "deleted_at"
      t.timestamps
    end

    add_index "application_status_types", ["deleted_at"], name: "index_application_status_types_on_deleted_at", using: :btree

    create_table "business_partners", force: :cascade do |t|
      t.integer "sba_application_id", null: false
      t.text    "first_name", null: false
      t.text    "last_name", null: false
      t.integer "marital_status"
      t.text    "address"
      t.text    "city"
      t.text    "state"
      t.text    "postal_code"
      t.text    "country"
      t.text    "home_phone"
      t.text    "business_phone"
      t.text    "email"
      t.integer "status"
      t.text    "ssn", null: false
      t.integer "title"
      t.datetime "deleted_at"
      t.timestamps
    end

    add_index "business_partners", ["sba_application_id", "first_name", "last_name", "ssn", "deleted_at"], name: "index_business_partners", unique: true, using: :btree

    create_table "certificate_status_types", force: :cascade do |t|
      t.text     "name",        null: false
      t.text     "description", null: false
      t.datetime "deleted_at"
      t.timestamps
    end

    add_index "certificate_status_types", ["deleted_at"], name: "index_certificate_status_types_on_deleted_at", using: :btree

    create_table "certificate_types", force: :cascade do |t|
      t.text     "name",             null: false
      t.text     "description"
      t.datetime "deleted_at"
      t.timestamps
      t.text     "title", null: false
      t.integer  "questionnaire_id"
    end

    add_index "certificate_types", ["deleted_at"], name: "index_certificate_types_on_deleted_at", using: :btree
    add_index "certificate_types", ["name", "deleted_at"], name: "index_certificate_types_on_name_and_deleted_at", unique: true, using: :btree

    create_table "certificates", force: :cascade do |t|
      t.integer  "sba_application_id", null: false
      t.integer  "organization_id", null: false
      t.integer  "certificate_status_type_id", null: false
      t.integer  "certificate_type_id", null: false
      t.datetime "issue_date",                 null: false
      t.datetime "expiry_date",                null: false
      t.datetime "deleted_at"
      t.timestamps
    end

    add_index "certificates", ["certificate_status_type_id"], name: "index_certificates_on_certificate_status_type_id", using: :btree
    add_index "certificates", ["certificate_type_id", "organization_id", "issue_date", "deleted_at"], name: "index_certificate_cert_type_org_issue", unique: true, using: :btree
    add_index "certificates", ["certificate_type_id"], name: "index_certificates_on_certificate_type_id", using: :btree
    add_index "certificates", ["organization_id"], name: "index_certificates_on_organization_id", using: :btree
    add_index "certificates", ["sba_application_id", "deleted_at"], name: "index_certificate_application", unique: true, using: :btree


    create_table "certificate_status_histories", force: :cascade do |t|
      t.integer  "certificate_id", null: false
      t.integer  "certificate_status_type_id", null: false
      t.datetime "status_reached_at",          null: false
      t.datetime "deleted_at"
      t.timestamps
    end

    add_index "certificate_status_histories", ["deleted_at"], name: "index_certificate_status_histories_on_deleted_at", using: :btree
    add_index "certificate_status_histories", ["certificate_id", "certificate_status_type_id", "deleted_at"], name: "index_cert_status_id", unique: true, using: :btree

    create_table "document_type_questions", force: :cascade do |t|
      t.integer  "document_type_id", null: false
      t.integer  "question_id", null: false
      t.datetime "deleted_at"
      t.timestamps
    end

    add_index "document_type_questions", ["document_type_id", "question_id", "deleted_at"], name: "index_document_type_questions_on_question_id", using: :btree

    create_table "document_types", force: :cascade do |t|
      t.text     "name", null: false
      t.text     "description"
      t.timestamps
      t.datetime "deleted_at"
    end

    add_index "document_types", ["name", "deleted_at"], name: "index_document_types_on_deleted_at", using: :btree

    create_table "documents", force: :cascade do |t|
      t.integer  "organization_id", null: false
      t.text     "stored_file_name", null: false
      t.text     "original_file_name", null: false
      t.integer  "document_type_id", null: false
      t.json     "file_metadata"
      t.datetime "deleted_at"
      t.timestamps
      t.text     "comment"
      t.boolean  "is_active", null: false
      t.text  "av_status", null: false
      t.boolean "valid_pdf"
    end

    add_index "documents", ["deleted_at"], name: "index_documents_on_deleted_at", using: :btree
    add_index "documents", ["organization_id"], name: "index_documents_on_organization_id", using: :btree
    add_index "documents", ["document_type_id"], name: "index_documents_on_document_type_id", using: :btree
    add_index "documents", ["av_status"], name: "index_documents_on_av_status", using: :btree
    add_index "documents", ["organization_id", "document_type_id", "stored_file_name", "deleted_at"], name: "index_documents_on_orgid_doctypeid_originalfilename", unique: true, using: :btree


    create_table "eligibility_results", force: :cascade do |t|
      t.integer  "evaluation_purpose_id", null: false
      t.integer  "owner_id", null: false
      t.text     "owner_type", null: false
      t.boolean  "result", null: false
      t.text     "reason"
      t.datetime "deleted_at"
      t.timestamps
    end

    add_index "eligibility_results", ["deleted_at"], name: "index_eligibility_results_on_deleted_at", using: :btree
    add_index "eligibility_results", ["evaluation_purpose_id", "owner_type", "owner_id", "deleted_at"], name: "index_eligibility_results_on_eval_purp_and_owner", unique: true, using: :btree

    create_table "eligible_naic_codes", force: :cascade do |t|
      t.integer  "certificate_type_id", null: false
      t.text     "naic_code",             null: false
      t.text     "naic_code_description", null: false
      t.datetime "deleted_at"
      t.timestamps
    end

    add_index "eligible_naic_codes", ["deleted_at"], name: "index_eligible_naic_codes_on_deleted_at", using: :btree
    add_index "eligible_naic_codes", ["naic_code", "certificate_type_id", "deleted_at"], name: "index_naic_codes_on_naic_code_and_cert_type", unique: true, using: :btree

    create_table "evaluation_purposes", force: :cascade do |t|
      t.text     "name",                null: false
      t.text     "title"
      t.integer  "certificate_type_id"
      t.integer  "questionnaire_id"
      t.datetime "deleted_at"
      t.json     "explanations"
      t.timestamps
    end

    add_index "evaluation_purposes", ["name", "certificate_type_id", "deleted_at"], name: "eval_purpose_name_cert_uniq_idx", unique: true, using: :btree

    create_table "organizations", force: :cascade do |t|
      t.text     "duns_number",         null: false
      t.text     "tax_identifier",      null: false
      t.text     "tax_identifier_type", null: false
      t.text     "business_type", null: false
      t.datetime "deleted_at"
      t.timestamps
      t.text     "folder_name", null: false
    end

    add_index "organizations", ["deleted_at"], name: "index_organizations_on_deleted_at", using: :btree
    add_index "organizations", ["duns_number", "tax_identifier", "tax_identifier_type", "deleted_at"], name: "index_org_duns_tax_ident_and_type", unique: true, using: :btree

    create_table "organizations_users", id: false, force: :cascade do |t|
      t.integer  "organization_id", null: false
      t.integer  "user_id", null: false
      t.datetime "deleted_at"
      t.timestamps
    end

    add_index "organizations_users", ["deleted_at"], name: "index_organizations_users_on_deleted_at", using: :btree
    add_index "organizations_users", ["organization_id", "user_id"], name: "index_organizations_users_on_organization_id_and_user_id", using: :btree

    create_table "question_presentations", force: :cascade do |t|
      t.integer  "question_id", null: false
      t.integer  "section_id", null: false
      t.integer  "position"
      t.text     "tooltip"
      t.json     "helpful_info"
      t.text     "question_override_title"
      t.datetime "deleted_at"
      t.json     "validation_rules", null: true
      t.timestamps
    end

    add_index "question_presentations", ["deleted_at"], name: "index_question_presentations_on_deleted_at", using: :btree
    add_index "question_presentations", ["question_id", "section_id", "deleted_at"], name: "index_question_pres_on_question_id_and_section_id", unique: true, using: :btree

    create_table "question_rules", force: :cascade do |t|
      t.integer  "question_type_id", null: false
      t.integer  "capability",                       null: false
      t.boolean  "mandatory",        default: false, null: false
      t.integer  "condition",        default: 0,     null: false
      t.text     "value"
      t.datetime "deleted_at"
      t.timestamps
    end

    add_index "question_rules", ["deleted_at"], name: "index_question_rules_on_deleted_at", using: :btree

    create_table "question_types", force: :cascade do |t|
      t.text     "name",        null: false
      t.text     "description"
      t.datetime "deleted_at"
      t.timestamps
      t.text     "title"
      t.text     "type"
    end

    add_index "question_types", ["deleted_at"], name: "index_question_types_on_deleted_at", using: :btree
    add_index "question_types", ["name", "deleted_at"], name: "index_question_types_on_name_and_deleted_at", unique: true, using: :btree

    create_table "questionnaires", force: :cascade do |t|
      t.text     "name", null: false
      t.text     "title"
      t.text     "submit_text",           default: "Submit", null: false
      t.boolean  "confirm",               default: false,    null: false
      t.boolean  "anonymous",             default: false,    null: false
      t.boolean  "determine_eligibility", default: false,    null: false
      t.boolean  "display_title",         default: true,     null: false
      t.boolean  "single_page",           default: false,    null: false
      t.datetime "deleted_at"
      t.timestamps
      t.integer  "root_section_id"
      t.integer  "first_section_id"
    end

    add_index "questionnaires", ["deleted_at"], name: "index_questionnaires_on_deleted_at", using: :btree

    create_table "questions", force: :cascade do |t|
      t.text     "name",             null: false
      t.text     "description"
      t.integer  "question_type_id", null: false
      t.datetime "deleted_at"
      t.text     "title"
      t.boolean  "multi", default: false
      t.json     "helpful_info"
      t.json     "sub_questions"
      t.json     "possible_values"
      t.timestamps
      t.text     "strategy"
    end

    add_index "questions", ["deleted_at"], name: "index_questions_on_deleted_at", using: :btree
    add_index "questions", ["name", "deleted_at"], name: "index_questions_on_name_and_deleted_at", unique: true, using: :btree

    create_table "roles", force: :cascade do |t|
      t.text     "name", null: false
      t.integer  "resource_id"
      t.text     "resource_type"
      t.datetime "deleted_at"
      t.timestamps
    end

    add_index "roles", ["deleted_at"], name: "index_roles_on_deleted_at", using: :btree
    add_index "roles", ["name", "resource_type", "resource_id", "deleted_at"], name: "index_roles_on_name_and_resource_type_and_resource_id", unique: true, using: :btree
    add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

    create_table "sba_application_documents", force: :cascade do |t|
      t.integer "sba_application_id", null: false
      t.integer "document_id", null: false
      t.datetime "deleted_at"
      t.timestamps
    end

    add_index "sba_application_documents", ["document_id", "sba_application_id", "deleted_at"], name: "index_sba_application_documents_on_sba_application_id", using: :btree

    create_table "sba_applications", force: :cascade do |t|
      t.integer  "application_status_type_id", null: false
      t.integer  "organization_id", null: false
      t.integer  "certificate_type_id", null: false
      t.datetime "application_start_date",     null: false
      t.datetime "deleted_at"
      t.timestamps
      t.json     "progress"
      t.json     "signature"
      t.datetime "application_submitted_at"
      t.integer  "root_section_id"
      t.integer  "first_section_id"
    end

    add_index "sba_applications", ["deleted_at"], name: "index_sba_applications_on_deleted_at", using: :btree

    create_table "section_rules", force: :cascade do |t|
      t.integer  "questionnaire_id", null: false
      t.integer  "from_section_id"
      t.integer  "to_section_id"
      t.datetime "deleted_at"
      t.timestamps
      t.json     "skip_info"
      t.json     "expression"
      t.integer  "sba_application_id"
      t.integer  "template_root_id"
      t.boolean  "dynamic",            default: false, null: false
      t.boolean  "is_last",            default: false, null: false
    end

    add_index "section_rules", ["deleted_at"], name: "index_section_rules_on_deleted_at", using: :btree

    create_table "sections", force: :cascade do |t|
      t.text     "name",                                     null: false
      t.text     "description"
      t.integer  "sba_application_id"
      t.text     "ancestry"
      t.datetime "deleted_at"
      t.timestamps
      t.text     "title"
      t.text     "submit_text",         default: "Continue", null: false
      t.integer  "questionnaire_id",                         null: false
      t.text     "type"
      t.integer  "template_id"
      t.json     "repeat"
      t.boolean  "displayable",         default: true
      t.integer  "position"
      t.integer  "answered_for_id"
      t.text     "answered_for_type"
      t.integer  "original_section_id"
      t.boolean  "dynamic", default: false
      t.text     "template_type", null: true
      t.json     "validation_rules", null: true
      t.boolean  "is_applicable", default: true, null: true
      t.boolean  "is_completed", default: false, null: false
    end

    add_index "sections", ["ancestry"], name: "index_sections_on_ancestry", using: :btree
    add_index "sections", ["name", "questionnaire_id", "sba_application_id", "deleted_at"], name: "index_sections_on_name_sba_app_and_deleted", unique: true, using: :btree
    add_index "sections", ["questionnaire_id"], name: "index_sections_on_questionnaire_id", using: :btree

    create_table "users", force: :cascade do |t|
      t.text     "name"
      t.text     "email", null: false
      t.text     "password_digest", null: false
      t.text     "last_login_at"
      t.datetime "deleted_at"
      t.timestamps
    end

    add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree

    create_table "users_roles", id: false, force: :cascade do |t|
      t.integer  "user_id", null: false
      t.integer  "role_id", null: false
      t.datetime "deleted_at"
      t.timestamps
    end

    add_index "users_roles", ["deleted_at"], name: "index_users_roles_on_deleted_at", using: :btree
    add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

    create_table "av_status_history", force: :cascade do |t|
      t.datetime "start_time"
      t.datetime "end_time"
      t.integer "total_documents"
      t.integer "total_errors"
      t.text "error_message"
      t.datetime "deleted_at"
      t.timestamps
    end

    add_index "av_status_history", ["deleted_at"], name: "index_av_status_history_on_deleted_at", using: :btree

    add_foreign_key "answer_documents", "answers"
    add_foreign_key "answer_documents", "documents"
    add_foreign_key "answers", "questions"
    add_foreign_key "answers", "sba_applications"
    add_foreign_key "applicable_questions", "evaluation_purposes"
    add_foreign_key "applicable_questions", "questions"
    add_foreign_key "application_status_histories", "application_status_types"
    add_foreign_key "application_status_histories", "sba_applications"
    add_foreign_key "certificate_types", "questionnaires"
    add_foreign_key "certificates", "certificate_status_types"
    add_foreign_key "certificates", "certificate_types"
    add_foreign_key "certificates", "organizations"
    add_foreign_key "certificates", "sba_applications"
    add_foreign_key "certificate_status_histories", "certificate_status_types"
    add_foreign_key "certificate_status_histories", "certificates"
    add_foreign_key "document_type_questions", "document_types"
    add_foreign_key "document_type_questions", "questions"
    add_foreign_key "documents", "organizations"
    add_foreign_key "documents", "document_types"
    add_foreign_key "eligibility_results", "evaluation_purposes"
    add_foreign_key "eligible_naic_codes", "certificate_types"
    add_foreign_key "evaluation_purposes", "certificate_types"
    add_foreign_key "evaluation_purposes", "questionnaires"
    add_foreign_key "organizations_users", "organizations"
    add_foreign_key "organizations_users", "users"
    add_foreign_key "question_presentations", "questions"
    add_foreign_key "question_presentations", "sections"
    add_foreign_key "questions", "question_types"
    add_foreign_key "sba_application_documents", "documents"
    add_foreign_key "sba_application_documents", "sba_applications"
    add_foreign_key "sba_applications", "application_status_types"
    add_foreign_key "sba_applications", "certificate_types"
    add_foreign_key "sba_applications", "organizations"
    add_foreign_key "business_partners", "sba_applications"
    add_foreign_key "sections", "questionnaires"
    add_foreign_key "sections", "sba_applications"
    add_foreign_key "section_rules", "questionnaires"
    add_foreign_key "section_rules", "sba_applications"
    add_foreign_key "users_roles", "roles"
    add_foreign_key "users_roles", "users"
    add_foreign_key "question_rules", "question_types"
  end
end