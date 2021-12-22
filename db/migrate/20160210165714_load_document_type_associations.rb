class LoadDocumentTypeAssociations < ActiveRecord::Migration
  def change
        
    q1 = Question.find_by(name: '8aq1')
    doc_type1 = DocumentType.find_by(name: '8(a) Certification')
    doc_type2 = DocumentType.find_by(name: 'Annual 8(a) Letter')
    doc_type3 = DocumentType.find_by(name: 'Miscellaneous')
    doc_type4 = DocumentType.find_by(name: 'Stock ledger')
    doc_type5 = DocumentType.find_by(name: 'Stock certificates')

    doc_type6 = DocumentType.find_by(name: 'Amendments to the Articles of Organization')
    doc_type7 = DocumentType.find_by(name: 'Annual TPC Letter')
    doc_type8 = DocumentType.find_by(name: 'Articles of incorporation')
    doc_type9 = DocumentType.find_by(name: 'Articles of incorporation amendments')
    doc_type10 = DocumentType.find_by(name: 'Birth certificates')

    doc_type11 = DocumentType.find_by(name: 'By-laws')
    doc_type12 = DocumentType.find_by(name: 'By-laws amendments')
    doc_type13 = DocumentType.find_by(name: 'DOT DBE Certification')
    doc_type14 = DocumentType.find_by(name: 'Doing Business As (DBA)')
    doc_type15 = DocumentType.find_by(name: 'Joint venture agreements')


    doc_type16 = DocumentType.find_by(name: 'Naturalization papers')
    doc_type17 = DocumentType.find_by(name: 'Operating agreement')
    doc_type18 = DocumentType.find_by(name: 'Operating agreement amendments')
    doc_type19 = DocumentType.find_by(name: 'Partnership agreement')
    doc_type20 = DocumentType.find_by(name: 'Partnership agreement amendments')

    doc_type21 = DocumentType.find_by(name: 'Third Party Certification')
    doc_type22 = DocumentType.find_by(name: 'Unexpired passports')
    doc_type23 = DocumentType.find_by(name: 'Voting agreement')
    doc_type24 = DocumentType.find_by(name: 'Separation agreement from spouse')


    if q1
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type1.id if doc_type1
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type2.id if doc_type2
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type3.id if doc_type3
    end

    q2 = Question.find_by(name: 'corp1_q1')
    if q2
      DocumentTypeQuestion.create question_id: q2.id, document_type_id: doc_type4.id if doc_type4
      DocumentTypeQuestion.create question_id: q2.id, document_type_id: doc_type5.id if doc_type5
      DocumentTypeQuestion.create question_id: q2.id, document_type_id: doc_type3.id if doc_type3
    end

    q3 = Question.find_by(name: 'corp1_q2')
    if q3
      DocumentTypeQuestion.create question_id: q3.id, document_type_id: doc_type15.id if doc_type15
      DocumentTypeQuestion.create question_id: q3.id, document_type_id: doc_type8.id if doc_type8
      DocumentTypeQuestion.create question_id: q3.id, document_type_id: doc_type11.id if doc_type11
      DocumentTypeQuestion.create question_id: q3.id, document_type_id: doc_type9.id if doc_type9
      DocumentTypeQuestion.create question_id: q3.id, document_type_id: doc_type19.id if doc_type19
      DocumentTypeQuestion.create question_id: q3.id, document_type_id: doc_type20.id if doc_type20
      DocumentTypeQuestion.create question_id: q3.id, document_type_id: doc_type23.id if doc_type23
      DocumentTypeQuestion.create question_id: q3.id, document_type_id: doc_type12.id if doc_type12
      DocumentTypeQuestion.create question_id: q3.id, document_type_id: doc_type18.id if doc_type18
      DocumentTypeQuestion.create question_id: q3.id, document_type_id: doc_type3.id if doc_type3
    end

    q4 = Question.find_by(name: 'llc_q1')
    if q4
      DocumentTypeQuestion.create question_id: q4.id, document_type_id: doc_type8.id if doc_type8
      DocumentTypeQuestion.create question_id: q4.id, document_type_id: doc_type6.id if doc_type6
      DocumentTypeQuestion.create question_id: q4.id, document_type_id: doc_type15.id if doc_type15
      DocumentTypeQuestion.create question_id: q4.id, document_type_id: doc_type3.id if doc_type3
    end

    q5 = Question.find_by(name: 'llc_q2')
    if q5
      DocumentTypeQuestion.create question_id: q5.id, document_type_id: doc_type17.id if doc_type17
      DocumentTypeQuestion.create question_id: q5.id, document_type_id: doc_type3.id if doc_type3
    end

    q6 = Question.find_by(name: 'oper1_q1')
    if q6
      DocumentTypeQuestion.create question_id: q6.id, document_type_id: doc_type10.id if doc_type10
      DocumentTypeQuestion.create question_id: q6.id, document_type_id: doc_type16.id if doc_type16
      DocumentTypeQuestion.create question_id: q6.id, document_type_id: doc_type22.id if doc_type22
      DocumentTypeQuestion.create question_id: q6.id, document_type_id: doc_type13.id if doc_type13
      DocumentTypeQuestion.create question_id: q6.id, document_type_id: doc_type3.id if doc_type3
    end

    q7 = Question.find_by(name: 'partn_q1')
    if q7
      DocumentTypeQuestion.create question_id: q7.id, document_type_id: doc_type19.id if doc_type19
      DocumentTypeQuestion.create question_id: q7.id, document_type_id: doc_type20.id if doc_type20
      DocumentTypeQuestion.create question_id: q7.id, document_type_id: doc_type3.id if doc_type3
    end

    q8 = Question.find_by(name: 'partn_q2')
    if q8
      DocumentTypeQuestion.create question_id: q8.id, document_type_id: doc_type15.id if doc_type15
      DocumentTypeQuestion.create question_id: q8.id, document_type_id: doc_type14.id if doc_type14
      DocumentTypeQuestion.create question_id: q8.id, document_type_id: doc_type3.id if doc_type3
    end

    q9 = Question.find_by(name: 'tpc1_q1')
    if q9
      DocumentTypeQuestion.create question_id: q9.id, document_type_id: doc_type21.id if doc_type21
      DocumentTypeQuestion.create question_id: q9.id, document_type_id: doc_type7.id if doc_type7
      DocumentTypeQuestion.create question_id: q9.id, document_type_id: doc_type3.id if doc_type3
    end

    q1 = Question.find_by(name: 'tpc3_q1')
    if q1
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type21.id if doc_type21
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type7.id if doc_type7
      DocumentTypeQuestion.create question_id: q1.id, document_type_id: doc_type3.id if doc_type3
    end

    q10 = Question.find_by(name: 'owner_divorced')
    if q10
      DocumentTypeQuestion.create question_id: q10.id, document_type_id: doc_type24.id if doc_type24
    end
  end
end
