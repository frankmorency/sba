namespace :populate do
  desc "Populate various sample datasets for regression testing"
  task sample_questionnaire: :environment do
    # TODO: Not sure where this is used - but CertificateType subclasses must now be used... CertificateType::Wosb for instance
    sample   = CertificateType.create!(name: 'sample', title: 'Sample Certificate tied to a Sample Questionnaire')

    yesno = QuestionType::Boolean.first
    yesnowithcommentrequiredonno = QuestionType::Boolean.where(name: 'yesno_with_comment_required_on_no').first
    yesnowithattachment = QuestionType::Boolean.where(name: 'yesno_with_attachment').first
    yesnowithattachmentrequiredonyes = QuestionType::Boolean.where(name: 'yesno_with_attachment_required_on_yes').first

    yesnona = QuestionType::YesNoNa.where(name: 'yesnona').first
    yesnonawithoptionalcommentonNA = QuestionType::YesNoNa.where(name: 'yesnona_with_comment').first
    yesnonawithrequiredcommentonNA = QuestionType::YesNoNa.where(name: 'yesnona_with_comment_required').first

    naicscode = QuestionType::NaicsCode.first

    yesnonawithcommentrequiredonNAanduploadrequiredonyes = QuestionType::YesNoNa.where(name: 'yesnona_with_comment_on_na_required_with_attachment_on_yes_required').first

    yesnonawithcommentrequiredonNAanduploadrequiredonNA = QuestionType::YesNoNa.where(name: 'yesnona_with_comment_on_na_required_with_attachment_on_na_required').first

    yesnonawithcommentoptionalonNAanduploadoptionlonNA = QuestionType::YesNoNa.where(name: 'yesnona_with_comment_on_na_optional_with_attachment_on_na_optional').first

    yesnonawithcommentrequiredonnoanduploadrequiredonno = QuestionType::YesNoNa.where(name: 'yesnona_with_comment_on_no_required_with_attachment_on_no_required').first

    sample_quest = Questionnaire.create! name: 'sample', title: 'Sample Questionnaire with all possible question types for Regression', anonymous: false, certificate_type: CertificateType.get('sample')
    sample = EvaluationPurpose.create! name: "sample_certification", title: "Sample Questionnaire", questionnaire: sample_quest

    sample_root = Section::Root.create! name: "sample_root", title: "Sample Root Section", questionnaire: sample_quest, submit_text: "Save & Continue"

    sample_top = Section::QuestionSection.create! name: "sample_top_section", title: "Sample Top Section", parent: sample_root, questionnaire: sample_quest, submit_text: "Save & Continue"
    sample_section = Section::QuestionSection.create! name: "sample_section", title: "Sample Section", parent: sample_top, questionnaire: sample_quest, submit_text: "Save & Continue"

    q1 = Question.new name: 'Sampleq1', question_type: yesno, title: 'This a sample Yes No question'
    q1.applicable_questions.new positive_response: "yes", evaluation_purpose: sample
    q1.question_presentations.new section: sample_section, position: 1, helpful_info: {default: "This is the sample helpful info for question Sampleq1"}
    q1.save!

    q2 = Question.new name: 'Sampleq2', question_type: yesnona, title: 'This a sample Yes No NA question'
    q2.applicable_questions.new positive_response: "yes", evaluation_purpose: sample
    q2.question_presentations.new section: sample_section, position: 2, helpful_info: {default: "This is the sample helpful info for question Sampleq2"}
    q2.save!

    q3 = Question.new name: 'Sampleq3', question_type: yesnonawithoptionalcommentonNA, title: 'This a sample Yes No NA question with optional comment on NA'
    q3.applicable_questions.new positive_response: "yes", evaluation_purpose: sample
    q3.question_presentations.new section: sample_section, position: 3, helpful_info: {default: "This is the sample helpful info for question Sampleq3"}
    q3.save!

    q4 = Question.new name: 'Sampleq4', question_type: yesnonawithrequiredcommentonNA, title: 'This a sample Yes No NA question with required comment on NA'
    q4.applicable_questions.new positive_response: "yes", evaluation_purpose: sample
    q4.question_presentations.new section: sample_section, position: 4, helpful_info: {default: "This is the sample helpful info for question Sampleq4"}
    q4.save!

    q5 = Question.new name: 'Sampleq5', question_type: yesnonawithcommentrequiredonNAanduploadrequiredonyes, title: 'This a sample Yes No NA question with required comment on NA and required upload on Yes'
    q5.applicable_questions.new positive_response: "yes", evaluation_purpose: sample
    q5.question_presentations.new section: sample_section, position: 5, helpful_info: {default: "This is the sample helpful info for question Sampleq4"}
    q5.save!

    q6 = Question.new name: 'Sampleq6', question_type: yesnonawithcommentrequiredonNAanduploadrequiredonNA, title: 'This a sample Yes No NA question with required comment on NA and required upload on NA'
    q6.applicable_questions.new positive_response: "yes", evaluation_purpose: sample
    q6.question_presentations.new section: sample_section, position: 6, helpful_info: {default: "This is the sample helpful info for question Sampleq5"}
    q6.save!

    q7 = Question.new name: 'Sampleq7', question_type: yesnonawithcommentoptionalonNAanduploadoptionlonNA, title: 'This a sample Yes No NA question with optional comment on NA and optional upload on NA'
    q7.applicable_questions.new positive_response: "yes", evaluation_purpose: sample
    q7.question_presentations.new section: sample_section, position: 7, helpful_info: {default: "This is the sample helpful info for question Sampleq7"}
    q7.save!

    q8 = Question.new name: 'Sampleq8', question_type: yesnonawithcommentrequiredonnoanduploadrequiredonno, title: 'This a sample Yes No NA question with required comment on No and required upload on No'
    q8.applicable_questions.new positive_response: "yes", evaluation_purpose: sample
    q8.question_presentations.new section: sample_section, position: 8, helpful_info: {default: "This is the sample helpful info for question Sampleq8"}
    q8.save!

    q9 = Question.new name: 'Sampleq9', question_type: yesnowithcommentrequiredonno, title: 'This a sample Yes No question with comment required on No'
    q9.applicable_questions.new positive_response: "yes", evaluation_purpose: sample
    q9.question_presentations.new section: sample_section, position: 9, helpful_info: {default: "This is the sample helpful info for question Sampleq9"}
    q9.save!

    doc_type3 = DocumentType.find_by(name: 'Miscellaneous')

    DocumentTypeQuestion.create question_id: q5.id, document_type_id: doc_type3.id if doc_type3
    DocumentTypeQuestion.create question_id: q6.id, document_type_id: doc_type3.id if doc_type3
    DocumentTypeQuestion.create question_id: q7.id, document_type_id: doc_type3.id if doc_type3
    DocumentTypeQuestion.create question_id: q8.id, document_type_id: doc_type3.id if doc_type3

    sample_quest.root_section_id = sample_root.id
    sample_quest.save!
  end

end
