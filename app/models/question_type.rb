class QuestionType < ActiveRecord::Base
  include NameRequirements

  acts_as_paranoid
  has_paper_trail

  TYPES = %w(
    yesno
    yesno_with_attachment
    yesno_with_attachment_required_on_yes
    yesno_with_attachment_optional_on_yes
    yesno_with_comment_optional_on_yes
    yesno_with_comment_required_on_yes
    yesno_with_comment_required_on_no
    yesno_with_comment_required
    yesno_with_table_required_on_yes
    yesno_with_table_and_attachment_required_on_yes
    yesno_dependent_on_yesno
    yesno_with_comment_on_no_required_with_attachment_on_yes_required
    yesno_with_comment_required_on_yes_with_attachment_required_on_yes
    yesno_with_attachment_required_on_no
    yesno_with_comment_required_on_yes_with_attachment_optional_on_yes
    yesno_with_comment_optional_on_yes_with_attachment_optional_on_yes
    yesnona
    yesnona_with_comment
    yesnona_with_comment_required
    yesnona_with_comment_required_on_no
    yesnona_with_attachment
    yesnona_with_attachment_required
    yesnona_with_comment_on_na_required_with_attachment_on_yes_required
    yesnona_with_comment_on_na_required_with_attachment_on_na_required
    yesnona_with_comment_on_na_optional_with_attachment_on_na_optional
    yesnona_with_comment_on_no_required_with_attachment_on_no_required
    yesnona_with_comment_on_no_required_with_attachment_on_yes_required
    yesnona_with_comment_required_on_yes
    yesnona_with_attachment_required_on_yes
    yesnona_with_comment_required_on_no
    naics_code
    owner_list
    six_questions_percentage
    date
    date_range
    address
    percentage
    full_address
    data_entry_grid_contracts_awarded
    certify_table_payments_distributions_compensation
    picklist
    picklist_with_comment_required
    picklist_with_radio_buttons
    picklist_with_radio_buttons_with_comment_required_on_last_radio_button
    picklist_with_radio_buttons_with_comment_optional_on_last_radio_button
    picklist_with_radio_buttons_with_attachment_required_on_last_radio_button
    checkbox
    checkboxes_with_optional_attachment_and_required_comment_on_all_except_last_selection
    checkboxes_with_comment_required_on_last_selection
    real_estate
    currency
    currency_with_comment_required_on_zero
    currency_with_comment_required_on_positive_value
    null_with_attachment_required
    repeating_question
    composite_question
    duns
    text_field_single_line
    text_field_multiline
    text_field_multiline_with_attachment
    text_field_multiline_with_attachment_optional
  ) unless defined?(TYPES)

  has_many :questions
  has_many :question_rules

  validates :name, inclusion: { in: TYPES, message: "must be a valid question type" }

  class << self
    TYPES.each do |type|
      define_method(type) do
        find_by(name: type)
      end
    end
  end

  def sub_questions
    []
  end

  def build_answer(user, app_id, presentation, answered_for, data, answer_params = nil)
    if presentation.question.strategy?
      strategy = "Strategy::Answer::#{presentation.question.strategy.to_s.demodulize}".constantize
    else
      strategy = "Strategy::Answer::#{presentation.question.question_type.class.to_s.demodulize}".constantize
    end
    strategy = strategy.new(user, app_id, presentation, answered_for, data)
    strategy.set_details
    strategy.params = answer_params if strategy.respond_to?(:params)
    strategy.set_value

    if strategy.valid?
      strategy.answer
    else
      raise strategy.to_error
    end
  end

  def cast(value)
    value
  end

  def partial
    raise_unknown
  end

  def validation_settings
    {
      rules: { required: true },
      messages: { required: "Please answer this question" },
    }
  end

  def display_name
    name.split("_").join(" ")
  end

  def evaluate(response, positive_response, options = {})
    raise_unknown
  end

  def picklist_with_radio_buttons?
    %w(picklist_with_radio_buttons picklist_with_radio_buttons_with_comment_required_on_last_radio_button picklist_with_radio_buttons_with_comment_optional_on_last_radio_button picklist_with_radio_buttons_with_attachment_required_on_last_radio_button).include?(name)
  end

  def currency_with_comment_required_on_positive_value?
    %w(currency_with_comment_required_on_positive_value).include?(name)
  end

  def yesno_with_comment_required?
    %w(yesno_with_comment_required).include?(name)
  end

  def picklist_with_comment_required?
    %w(picklist_with_comment_required).include?(name)
  end

  def custom_checkbox?
    %w(checkboxes_with_optional_attachment_and_required_comment_on_all_except_last_selection checkboxes_with_comment_required_on_last_selection).include?(name)
  end

  def currency?
    return true if name == "currency"
    return false
  end

  private

  def raise_unknown
    raise "Unknown question type: #{name} (#{type})"
  end
end
