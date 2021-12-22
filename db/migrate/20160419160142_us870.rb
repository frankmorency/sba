class Us870 < ActiveRecord::Migration
  def change
    
    q = Question.find_by(name: 'woman_financial_condition')
    q.update_attribute('question_type_id', QuestionType.find_by(name: 'yesno_with_attachment_required_on_yes').id)
    q.save!

    doc_type1 = DocumentType.create! name: "1040"
    doc_type2 = DocumentType.create! name: "W2"
    doc_type3 = DocumentType.create! name: "4506-T"

    if q
      DocumentTypeQuestion.create question_id: q.id, document_type_id: doc_type1.id if doc_type1
      DocumentTypeQuestion.create question_id: q.id, document_type_id: doc_type2.id if doc_type2
      DocumentTypeQuestion.create question_id: q.id, document_type_id: doc_type3.id if doc_type3
    end
  end
end
