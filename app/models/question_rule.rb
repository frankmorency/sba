class QuestionRule < ActiveRecord::Base
  acts_as_paranoid
  has_paper_trail

  # NOTE: ONLY ADD TO THE END OF THIS LIST OR EXISTING STATUSES WILL CHANGE !!!
  enum capability: %w(add_comment add_attachment)
  enum condition: %w(always never equal_to not_equal_to)

  belongs_to :question_type

  def to_s
    "#{mandatory? ? "require" : "allow"} #{capability}"
  end

  def always_show?
    always?
  end

  def show_by_default?
    mandatory? && always?
  end

  # TODO: part of to_json or presenter class
  def validation_settings(question)
    if mandatory?
      {
        rules: {
          required: conditional_logic(question),
        },
        messages: {
          required: model_type[:message],
        },
      }
    else
      {
        rules: {
          required: false,
        },
      }
    end
  end

  def conditional_logic(question)
    return true if always?
    return false if never?

    case question_type
    when QuestionType::Boolean, QuestionType::YesNoNa, QuestionType::Table
      ["input[name='#{question.dom_id}']:checked", condition, value]
    when QuestionType::Picklist
      ["input[name='#{question.dom_id}']:checked", condition, question.possible_values.last] if question_type.picklist_with_radio_buttons?
    when QuestionType::Checkbox
      if question_type.custom_checkbox?
        config_show_comment = question_type.config_options&.dig("show_comment")
        if config_show_comment == "last_only"
          ["input:checkbox[name='#{question.dom_id}[]']:last:checked"]
        else
          ["input:checkbox[name='#{question.dom_id}[]']:not(:last):checked"]
        end
      end
    end
  end

  def dom_id(question)
    question.dom_id(model_type[:key])
  end

  private

  def model_type
    if add_comment?
      { key: "comment", message: "Comment is required" }
    elsif add_attachment?
      { key: "attachment", message: "Attachment is required" }
    end
  end
end
