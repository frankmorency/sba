class AddDocumentTypeToReconsiderationQuestion < ActiveRecord::Migration
  def change
    doc_type = DocumentType.create! name: "Reconsideration documentation"
    q = Question.find_by(name: 'reconsideration_attachment_question')

    if q
      DocumentTypeQuestion.create question_id: q.id, document_type_id: doc_type.id if doc_type
    end
  end
end
