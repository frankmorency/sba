class AddDocumentTypesFor8aAnnual < ActiveRecord::Migration
  def change
    # New Doc Types
    dt1 = DocumentType.create! name: "SBA Form Benefit Report"
    dt2 = DocumentType.create! name: "Promissory Note"
    dt3 = DocumentType.create! name: "Explanation of credit extended"
    dt4 = DocumentType.create! name: "SBA Form 1790"
    dt5 = DocumentType.create! name: "Compensation Explanation"
    dt6 = DocumentType.create! name: "Current affiliates"
    dt7 = DocumentType.create! name: "8(a) Mentor-Protégé Worksheet"
    dt8 = DocumentType.create! name: "Capability Statement"
    dt9 = DocumentType.create! name: "Other"
    dt10 = DocumentType.create! name: "Promissory notes"
    dt11 = DocumentType.create! name: "Loan Description"
    dt12 = DocumentType.create! name: "Salary Explanation"
    dt13 = DocumentType.create! name: "List of affiliates"
    dt14 = DocumentType.create! name: "SBA 8(a) Business Plan"
    dt15 = DocumentType.create! name: "8(a) Contract Worksheet"

    q = Question.find_by(name: "explain_changes")
    if q
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Articles of incorporation").id
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("By-laws amendments").id
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Stock ledger").id
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Stock certificates").id
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Operating agreement amendments").id
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Stock Agreements").id
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Partnership agreement amendments").id
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Other").id
    end

    q = Question.find_by(name: "integrity_character_changes")
    if q
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Pending lawsuit details").id
    end

    q = Question.find_by(name: "adverse_actions")
    if q
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Pending lawsuit details").id
    end


    q = Question.find_by(name: "entity_owned")
    if q
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("SBA Form Benefit Report").id
    end

    q = Question.find_by(name: "annual_review_tax_returns")
    if q
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Firm income tax returns").id
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Tax Form").id
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Tax Schedule").id
    end

    q = Question.find_by(name: "annual_review_financials")
    if q
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Balance Sheet").id
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Profit and Loss Statement").id
    end

    q = Question.find_by(name: "payments_and_excessive_withdrawals_q2")
    if q
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Promissory notes").id
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Loan Description").id
    end

    q = Question.find_by(name: "outside_assistance_q1")
    if q
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("SBA Form 1790").id
    end

    q = Question.find_by(name: "outside_assistance_q2")
    if q
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("SBA Form 1790").id
    end

    q = Question.find_by(name: "compensation_q1")
    if q
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Salary Explanation").id
    end

    q = Question.find_by(name: "changes_to_affiliates_q1")
    if q
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("List of affiliates").id
    end

    q = Question.find_by(name: "eight_a_annual_mentor_protege_program")
    if q
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("8(a) Mentor-Protégé Worksheet").id
    end

    q = Question.find_by(name: "eight_a_annual_business_plan_upload")
    if q
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("SBA 8(a) Business Plan").id
    end

    q = Question.find_by(name: "eight_a_annual_marketing_capability_upload")
    if q
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("Capability Statement").id
    end

    q = Question.find_by(name: "eight_a_annual_business_contracts_past_year")
    if q
      DocumentTypeQuestion.create! question_id: q.id, document_type_id: DocumentType.find_by_name("8(a) Contract Worksheet").id
    end
  end
end
