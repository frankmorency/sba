class AddCorrectDocumentTypeToCharacterQuestionnaire < ActiveRecord::Migration
  def change
    
    document_type = DocumentType.find_by_name('Character')
    document_type.update_attributes(name: 'Character Document')

    q1 = Question.find_by(name: 'character_16a')
    q2 = Question.find_by(name: 'character_16b')
    q3 = Question.find_by(name: 'character_16c')
    q4 = Question.find_by(name: 'character_16d')

    doc_type_ques1 = DocumentTypeQuestion.find_by_question_id(q1.id)
    doc_type_ques1.update_attributes(document_type_id: document_type.id)

    doc_type_ques2 = DocumentTypeQuestion.find_by_question_id(q2.id)
    doc_type_ques2.update_attributes(document_type_id: document_type.id)

    doc_type_ques3 = DocumentTypeQuestion.find_by_question_id(q3.id)
    doc_type_ques3.update_attributes(document_type_id: document_type.id)

    doc_type_ques4 = DocumentTypeQuestion.find_by_question_id(q4.id)
    doc_type_ques4.update_attributes(document_type_id: document_type.id)

  end
end
