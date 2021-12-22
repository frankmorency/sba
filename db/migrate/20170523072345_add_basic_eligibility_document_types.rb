class AddBasicEligibilityDocumentTypes < ActiveRecord::Migration
  def change

    
    doc = DocumentType.find_by(name: 'Acquisition Documents')
    q = Question.find_by(name: 'previous_participant_assets_over_50_percent')
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: doc.id

    doc = DocumentType.find_by(name: 'Representative Information Form')
    q = Question.find_by(name: 'outside_consultant')
    DocumentTypeQuestion.create! question_id: q.id, document_type_id: doc.id

  end
end
