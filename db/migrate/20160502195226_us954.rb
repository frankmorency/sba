class Us954 < ActiveRecord::Migration
  def change
    
    yesno_with_attachment_optional_on_yes = QuestionType::Boolean.new name: 'yesno_with_attachment_optional_on_yes', title: 'Yes or No with Attachment Optional'
    yesno_with_attachment_optional_on_yes.question_rules.new mandatory: false, value: 'yes', capability: :add_attachment, condition: :equal_to
    yesno_with_attachment_optional_on_yes.save!

    q = Question.find_by(name: 'oper3_q2')
    q.update_attribute('question_type_id', QuestionType.find_by(name: 'yesno_with_attachment_optional_on_yes').id)
    q.save!

    doc_type1 = DocumentType.create! name: "Resume"

    if q
      DocumentTypeQuestion.create question_id: q.id, document_type_id: doc_type1.id if doc_type1
    end
  end
end
