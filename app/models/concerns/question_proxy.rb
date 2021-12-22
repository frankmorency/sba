module QuestionProxy
  extend ActiveSupport::Concern

  included do
    delegate  :rules, :name, :title, :description, to: :question
  end

  def prepopulate
    question.prepopulate
  end

  def question_type
    question.question_type
  end

  def has_comment_rule?
    ! rules.add_comment.empty?
  end

  def has_attachment_rule?
    ! rules.add_attachment.empty?
  end

  def unique_id
    unless question
      raise self.inspect
    end
    question.id
  end

  def ==(other)
    if other.respond_to? :unique_id
      unique_id == other.unique_id
    else
      super
    end
  end
end
