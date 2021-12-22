class AddDocTypesToMppQuestions < ActiveRecord::Migration
  def change
    
    q1 = Question.find_by(name: '8a_certified')

    doc_type1 = DocumentType.new(name: '8(a) Mentor-Protégé Approval Letter')
    doc_type1.save!

    doc_type2 = DocumentType.new(name: '8(a) Mentor-Protégé Agreement')
    doc_type2.save!

    if q1
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type1.id if doc_type1
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type2.id if doc_type2
    end

    q2 = Question.find_by(name: 'redetermination_letter')

    doc_type3 = DocumentType.new(name: 'SBA Size Redetermination Letter')
    doc_type3.save!

    if q2
      DocumentTypeQuestion.create question_id: q2.id, document_type_id: doc_type3.id if doc_type3
    end

    q3 = Question.find_by(name: 'mpp_completion_cert')

    doc_type4 = DocumentType.new(name: 'Mentor-Protégé Program Training Certificate')
    doc_type4.save!

    if q3
      DocumentTypeQuestion.create question_id: q3.id, document_type_id: doc_type4.id if doc_type4
    end

    q4 = Question.find_by(name: 'protege_biz_plan')

    doc_type5 = DocumentType.new(name: 'Business Plan')
    doc_type5.save!

    if q4
      DocumentTypeQuestion.create question_id: q4.id, document_type_id: doc_type5.id if doc_type5
    end

    q5 = Question.find_by(name: 'mpp_active_agreemets')

    doc_type6 = DocumentType.new(name: 'Mentor-Protégé Agreement')
    doc_type6.save!

    if q5
      DocumentTypeQuestion.create question_id: q5.id, document_type_id: doc_type6.id if doc_type6
    end

    q6 = Question.find_by(name: 'mpp_agreement')

    if q6
      DocumentTypeQuestion.create question_id: q6.id, document_type_id: doc_type6.id if doc_type6
    end

    q7 = Question.find_by(name: 'mentor_mpp_training_cert')

    if q7
      DocumentTypeQuestion.create question_id: q7.id, document_type_id: doc_type4.id if doc_type4
    end


  end
end






