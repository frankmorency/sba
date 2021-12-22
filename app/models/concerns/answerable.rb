module Answerable
  extend ActiveSupport::Concern

  def set_answers(answer_params, options = {})
    @answers_set = true
    app_id = options[:sba_application] && options[:sba_application].id
    org = SbaApplication.find(app_id).organization

    answer_params.each do |presentation_id, data|
      next unless data && data.has_key?('value') || data.has_key?(:value)
      data = data.with_indifferent_access
      data[:document_ids] = Array.wrap(data[:document_ids]).map(&:to_i)
      question_presentation = QuestionPresentation.joins(:question).find(presentation_id)
      rule = question_presentation.rules.add_attachment.first

      ans = Answer.new
      ans = Answer.find data[:answer_id] if data[:answer_id]

      if rule && rule.mandatory? && (rule.value == data[:value]) && ['add_attachment'].include?(rule.capability) && data[:document_ids].empty? && ans.documents.count == 0
        raise Strategy::Answer::ValidationError.new('This question requires an attachment')
      end

      if rule && rule.mandatory? && (rule.value == data[:value]) && ['add_comment'].include?(rule.capability) && data[:comment].empty? && ans.comment.nil?
        raise Strategy::Answer::ValidationError.new('This question requires a comment')
      end
    end

    Answer.transaction do
      answer_params.each do |presentation_id, data|
        next unless data && data.has_key?('value') || data.has_key?(:value)
        data = data.with_indifferent_access
        # Sanitize document ids to make sure there's no SQL
        data[:document_ids] = Array.wrap(data[:document_ids]).map(&:to_i)
        data[:delete_document_ids] = Array.wrap(data[:delete_document_ids]).map(&:to_i)

        ans = Answer.new
        ans = Answer.find data[:answer_id] if data[:answer_id]
        # to fix - APP-1765 . Pre-populate answers not sending previously attached document ids from the client side. Basically copying it from the previous answer.
        data[:document_ids] = ans.documents.ids.map(&:to_i) if data[:document_ids].empty? && ans.documents.count > 0

        presentation = QuestionPresentation.joins(:question).find(presentation_id)

        answered_for = AnsweredFor.factory(app_id, data.with_indifferent_access)

        answer = presentation.question.question_type.build_answer(self, app_id, presentation, answered_for, data, answer_params)

        answer.save!

        if dynamic_question?(options[:section], presentation)
          options[:section].build_sections_and_rules!(answer, options[:brand_new_answered_for_ids])
        end

        # Scope document to the application's org
        attached_docs = org.documents.find(data[:document_ids]).map(&:id)
        Document.make_association(answer, attached_docs) if data.has_key?(:document_ids)
        if data.has_key?(:answer_id) && data.has_key?(:delete_document_ids)
          removed_docs = org.documents.find(data[:delete_document_ids]).map(&:id)
          Document.destroy_answer_document_associations(data[:answer_id], removed_docs)
        end
        answer.save! # associated documents
      end
    end
  end

  def answers_set?
    @answers_set
  end

  def dynamic_question?(section, presentation)
    section && section.is_a?(Section::Spawner) && section.decision_question == presentation
  end
end