class AddUniqueConstraintsSql < ActiveRecord::Migration
  def change
    execute <<-SQL
      ALTER TABLE "sbaone"."answers" ADD CONSTRAINT "UK_answers" UNIQUE ("sba_application_id", "owner_type", "owner_id", "answered_for_type", "answered_for_id", "question_id", "deleted_at");
      ALTER TABLE "sbaone"."answer_documents" ADD CONSTRAINT "UK_certification_answer_document" UNIQUE ("document_id","answer_id", "deleted_at");
      ALTER TABLE "sbaone"."applicable_questions" ADD CONSTRAINT "UK_applicable_question" UNIQUE ("question_id","evaluation_purpose_id", "deleted_at");
      ALTER TABLE "sbaone"."application_status_histories" ADD CONSTRAINT "UK_application_status_histories" UNIQUE ("sba_application_id", "application_status_type_id", "deleted_at");
      ALTER TABLE "sbaone"."application_status_types" ADD CONSTRAINT "UK_application_status_type" UNIQUE ("name", "deleted_at");
      ALTER TABLE "sbaone"."business_partners" ADD CONSTRAINT "UK_business_partners" UNIQUE ("sba_application_id", "first_name", "last_name", "ssn", "deleted_at");
      ALTER TABLE "sbaone"."certificates" ADD CONSTRAINT "UK_certificate2" UNIQUE ("certificate_type_id", "organization_id", "issue_date", "deleted_at");
      ALTER TABLE "sbaone"."certificates" ADD CONSTRAINT "UK_certificate" UNIQUE ("sba_application_id");
      ALTER TABLE "sbaone"."certificate_status_types" ADD CONSTRAINT "UK_certificate_ststus_type" UNIQUE ("name", "deleted_at");
      ALTER TABLE "sbaone"."certificate_types" ADD CONSTRAINT "certificate_type_ukey" UNIQUE ("name", "deleted_at");
      ALTER TABLE "sbaone"."certificate_status_histories" ADD CONSTRAINT "UK_certificate_status_histories" UNIQUE ("certificate_id", "certificate_status_type_id", "deleted_at");
      ALTER TABLE "sbaone"."documents" ADD CONSTRAINT "UK_document" UNIQUE ("organization_id", "document_type_id", "stored_file_name", "deleted_at");
      ALTER TABLE "sbaone"."document_types" ADD CONSTRAINT "UK_document_type" UNIQUE ("name", "deleted_at");
      ALTER TABLE "sbaone"."document_type_questions" ADD CONSTRAINT "UK_document_type_questions" UNIQUE ("document_type_id", "question_id", "deleted_at");
      ALTER TABLE "sbaone"."eligible_naic_codes" ADD CONSTRAINT "UK_eligible_naic_code" UNIQUE ("certificate_type_id","naic_code", "deleted_at");
      ALTER TABLE "sbaone"."eligibility_results" ADD CONSTRAINT "UK_eligibility" UNIQUE ("evaluation_purpose_id", "owner_type", "owner_id", "deleted_at");
      ALTER TABLE "sbaone"."evaluation_purposes" ADD CONSTRAINT "evaluation_purposes_ukey" UNIQUE ("name","certificate_type_id","deleted_at");
      ALTER TABLE "sbaone"."organizations" ADD CONSTRAINT "organization_hash" UNIQUE ("folder_name", "deleted_at");
      ALTER TABLE "sbaone"."organizations" ADD CONSTRAINT "UK_organization" UNIQUE ("duns_number","tax_identifier","tax_identifier_type", "deleted_at");
      ALTER TABLE "sbaone"."organizations_users" ADD CONSTRAINT "uk_firm_authenticated_user" UNIQUE ("user_id","organization_id", "deleted_at");
      ALTER TABLE "sbaone"."questions" ADD CONSTRAINT "UK_question" UNIQUE ("name", "deleted_at");
      ALTER TABLE "sbaone"."question_presentations" ADD CONSTRAINT "UK_presentation" UNIQUE ("question_id","section_id", "deleted_at");
      ALTER TABLE "sbaone"."question_rules" ADD CONSTRAINT "UK_question_rules" UNIQUE ("question_type_id", "capability", "mandatory", "condition", "value", "deleted_at");
      ALTER TABLE "sbaone"."question_types" ADD CONSTRAINT "UK_question_type" UNIQUE ("name", "deleted_at");
      ALTER TABLE "sbaone"."questionnaires" ADD CONSTRAINT "UK_questionnaires" UNIQUE ("name", "deleted_at");
      ALTER TABLE "sbaone"."roles" ADD CONSTRAINT "UK_Role" UNIQUE ("name", "resource_type", "resource_id", "deleted_at");
      ALTER TABLE "sbaone"."sba_application_documents" ADD CONSTRAINT "UK_sba_application_documents" UNIQUE ("document_id", "sba_application_id", "deleted_at");
      ALTER TABLE "sbaone"."sba_applications" ADD CONSTRAINT "UK_application" UNIQUE ("certificate_type_id","organization_id","application_start_date", "deleted_at");
      ALTER TABLE "sbaone"."sections" ADD CONSTRAINT "UK_grouping_purpose" UNIQUE ("name", "questionnaire_id", "sba_application_id", "deleted_at");
      --TODO: expression should be part of below unique contraint, but its tricky since it is json field, need to figure out at some point.
      ALTER TABLE "sbaone"."section_rules" ADD CONSTRAINT "section_rules_ukey" UNIQUE ("sba_application_id", "questionnaire_id", "from_section_id","to_section_id","deleted_at");
      ALTER TABLE "sbaone"."users" ADD CONSTRAINT "UK_authenticated_user" UNIQUE ("email", "deleted_at");
      ALTER TABLE "sbaone"."users_roles" ADD CONSTRAINT "UK_users_roles" UNIQUE ("user_id","role_id", "deleted_at");
    SQL
  end
end
