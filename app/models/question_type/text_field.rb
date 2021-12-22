require 'question_type'

class QuestionType::TextField < QuestionType

  SINGLE_LINE_INDICATOR = 'single'
  MULTILINE_INDICATOR = 'multi'

  DEFAULT_SINGLE_LINE_MIN_CHARACTERS_ALLOWED = 1
  DEFAULT_SINGLE_LINE_MAX_CHARACTERS_ALLOWED = 150
  DEFAULT_MULTILINE_MIN_CHARACTERS_ALLOWED = 5
  DEFAULT_MULTILINE_MAX_CHARACTERS_ALLOWED = 1000

  validates :config_options, presence: true
  before_save :validate_num_lines_value
  before_save :validate_min
  before_save :validate_max
  before_save :validate_length_relation

  def partial
    'question_types/text_field'
  end

  def evaluate(response, positive_response, options = {})
    Answer::SUCCESS
  end

  def is_multi?
    self.config_options['num_lines'] == MULTILINE_INDICATOR
  end

  def is_single?
    self.config_options['num_lines'] == SINGLE_LINE_INDICATOR
  end

  def self.get_num_lines
    self.config_options['num_lines']
  end

  def num_lines_set?
    data = self.config_options.with_indifferent_access
    data.key?(:num_lines) && (self.is_multi? || self.is_single?)
  end

  def validate_num_lines_value
    raise "Please include a valid number of lines value ('#{SINGLE_LINE_INDICATOR}' or '#{MULTILINE_INDICATOR}')" unless self.num_lines_set?
  end

  def validate_min
    self.validate_length_option :min
  end

  def validate_max
    self.validate_length_option :max
  end

  def validate_length_option option
    data = self.config_options.with_indifferent_access
    key_exists = data.key?(option)
    if key_exists
      int = Integer(data[option]) rescue false
      raise 'Character length value must be an integer' unless int
    end
  end

  def validate_length_relation
    data = self.config_options.with_indifferent_access
    if data.key?(:min) && data.key?(:max)
      raise 'Make sure minimum characters allowed is less than maximum characters allowed' if data[:min].to_i > data[:max].to_i
    elsif data.key?(:min)
      self.compare_with_default(data, :min)
    elsif data.key?(:max)
      self.compare_with_default(data, :max)
    end
  end

  def compare_with_default (data, option)
    case data[:num_lines]
      when SINGLE_LINE_INDICATOR
        if [:min].include?(option)
          raise 'Make sure minimum characters allowed is less than maximum characters allowed' if data[option].to_i > DEFAULT_SINGLE_LINE_MAX_CHARACTERS_ALLOWED
        else
          raise 'Make sure maximum characters allowed is greater than minimum characters allowed' if data[option].to_i < DEFAULT_SINGLE_LINE_MIN_CHARACTERS_ALLOWED
        end
      when MULTILINE_INDICATOR
        if [:min].include?(option)
          raise 'Make sure minimum characters allowed is less than maximum characters allowed' if data[:min].to_i > DEFAULT_MULTILINE_MAX_CHARACTERS_ALLOWED
        else
          raise 'Make sure maximum characters allowed is greater than minimum characters allowed' if data[:max].to_i < DEFAULT_MULTILINE_MIN_CHARACTERS_ALLOWED
        end
    end
  end

  def chars(option)
    data = self.config_options.with_indifferent_access
    case data[:num_lines]
      when SINGLE_LINE_INDICATOR
        data.key?(option) ? data[option] : "QuestionType::TextField::DEFAULT_SINGLE_LINE_#{option.upcase}_CHARACTERS_ALLOWED".constantize
      when MULTILINE_INDICATOR
        data.key?(option) ? data[option] : "QuestionType::TextField::DEFAULT_MULTILINE_#{option.upcase}_CHARACTERS_ALLOWED".constantize
    end
  end


end