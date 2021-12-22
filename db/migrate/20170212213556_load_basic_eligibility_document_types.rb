class LoadBasicEligibilityDocumentTypes < ActiveRecord::Migration
  def change
    
    q1 = Question.find_by(name: 'previous_participant_assets_over_50_percent')
    doc_type1 = DocumentType.create! name: "Acquisition Documents"

    if q1
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type1.id if doc_type1
    end

    q2 = Question.find_by(name: 'outside_consultant')
    doc_type2 = DocumentType.create! name: "Representative Information Form"

    if q2
      DocumentTypeQuestion.create question_id: q2.id, document_type_id: doc_type2.id if doc_type2
    end

  end
end
