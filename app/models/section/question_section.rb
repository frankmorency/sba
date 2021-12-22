require_relative '../section'

class Section::QuestionSection < Section
  def update_progress(answer_params, sba_application)
    #remove document ids that are already associated to this application
    document_ids = get_attached_document_ids(answer_params).uniq.delete_if {|document_id| sba_application.document_ids.include?(document_id)}

    # TODO: Ensure this document belongs to one of the user's orgs first
    Document.make_association(sba_application, document_ids)

    # TODO: See if the following todo still applies...
    # TODO: See if this todo still applies...
    # TODO - delete assocation bewtween docs and app
    # destroy_document_associations(@sba_application.id, data[:delete_document_ids]) if data.has_key?(:delete_document_ids)

    # destroy all document associations to this answer if user selected an answer value that does not require attachments
    answer_params.each do |presentation_id, data|

      question_presentation = QuestionPresentation.find(presentation_id)
      answered_for = AnsweredFor.factory(sba_application.id, data) # need to pass in answered for...
      answer = Answer.for_application(sba_application, question_presentation, answered_for)
      next if data[:value] == 'Legally Separated' && answer.question.question_type.is_a?(QuestionType::Picklist)

      if question_presentation && question_presentation.has_attachment_rule? && data[:value] != question_presentation.rules.add_attachment.first.value
        if answer && !(answer.question.question_type.is_a?(QuestionType::Null) || answer.question.question_type.is_a?(QuestionType::TextField) || answer.question.question_type.is_a?(QuestionType::Checkbox))
          answer.documents.each do |document|
            answer_doc = AnswerDocument.find_by(document_id: document.id, answer_id: answer.id) if answer
            answer_doc.destroy if answer_doc.present?
          end
        end
      end
    end

    super
  end

  def custom_layout
    template && template.custom_layout
  end

  def get_attached_document_ids(answer_params)
    document_ids = []
    answer_params.each do |presentation_id, data|
      next unless data && data.has_key?(:document_ids)
      data[:document_ids].each do |document_id|
        document_ids << document_id
      end
    end
    document_ids
  end
end