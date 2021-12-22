class De255FixDocumentType < ActiveRecord::Migration
  def change
    


    q1 = Question.find_by(name: 'corp5_q1')
    doc_type1 = DocumentType.find_by(name: 'Articles of incorporation')
    doc_type2 = DocumentType.find_by(name: 'Stock ledger')

    doc_type3 = DocumentType.create! name: "Copies of stock certificates (front and back)"
    doc_type4 = DocumentType.create! name: "Stock Agreements"
    doc_type5 = DocumentType.create! name: "Meeting Minutes"
    doc_type6 = DocumentType.create! name: "Corporate Bylaws and Amendments"

    if q1
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type1.id if doc_type1
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type2.id if doc_type2
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type3.id if doc_type3
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type4.id if doc_type4
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type5.id if doc_type5
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type6.id if doc_type6
    end

  end
end
