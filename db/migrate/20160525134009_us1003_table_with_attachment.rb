class Us1003TableWithAttachment < ActiveRecord::Migration
  def change
        yesno_with_table_and_attachment_required_on_yes = QuestionType::Table.new name: 'yesno_with_table_and_attachment_required_on_yes', title: 'Yes or No with Table and Attachment Required on Yes'
    yesno_with_table_and_attachment_required_on_yes.question_rules.new mandatory: true, value: 'yes', capability: :add_attachment, condition: :equal_to
    yesno_with_table_and_attachment_required_on_yes.save!

    q = Question.find_by(name: 'roth_ira')
    q.update_attribute('question_type_id', QuestionType.find_by(name: 'yesno_with_table_and_attachment_required_on_yes').id)
    q.save!

    q2 = Question.find_by(name: 'other_retirement_accounts')
    q2.update_attribute('question_type_id', QuestionType.find_by(name: 'yesno_with_table_and_attachment_required_on_yes').id)
    q2.save!

    doc_type1 = DocumentType.create! name: "Retirement Account Terms and Conditions"

    if q
      DocumentTypeQuestion.create question_id: q.id, document_type_id: doc_type1.id if doc_type1
    end

    if q2
      DocumentTypeQuestion.create question_id: q2.id, document_type_id: doc_type1.id if doc_type1
    end
  end
end
