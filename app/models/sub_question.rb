class SubQuestion
  include ActiveModel::Model

  attr_accessor :question_type, :name, :header, :title, :title_wrapper_tag, :position, :possible_values, :positive_response, :id, :value, :array_index

  validates :name, presence: true
  validates :title, presence: true
  validates :question_type, presence: true

  def self.from_json(json)
    new json.is_a?(String) ? JSON.parse(json) : json
  end

  def initialize(options = {})
    options = options.with_indifferent_access
    super(options)
    @question_type = QuestionType.find_by(name: options[:question_type]) if options[:question_type].is_a?(String)
  end

  def name_with_index
    "#{name}_#{array_index}"
  end

  def as_presentation
    Struct.new(:failure_message, :maybe_message, :unique_id, :question).new(nil, nil, id, self)
  end

  def as_json(options = {})
    {
        id: id,
        question_type: type_name,
        name: name,
        header: header,
        title: title,
        title_wrapper_tag: title_wrapper_tag,
        position: position,
        possible_values: possible_values,
        positive_response: positive_response,
        # strategy: strategy...
    }
  end

  def to_strategy(user, app_id, answered_for, value)
    sub_class = question_type.class.to_s.demodulize # or strategy...
    strategy = "Strategy::Answer::#{sub_class}".constantize.new(user, app_id, as_presentation, answered_for, {value: value})
    strategy.set_details
    strategy.set_value
    strategy.answer.question_type = question_type
    strategy
  end

  def dom_id(type = 'value')
    "answers[#{id}]#{array_index ? "[#{array_index}]" : ''}[#{position}][#{type}]"
  end

  def has_table_rule?
    false
  end

  def has_attachment_rule?
    false
  end

  def has_comment_rule?
    false
  end

  def rules
    []
  end

  def unique_id
    id
  end

  def ==(other)
    unique_id == other.unique_id
  end

  def type_name
    question_type.name
  end

  def positive_response_for(evaluation_purpose_name)
    positive_response
  end

  def failure_message
   'Something went terribly wrong'
  end

  def maybe_message
    "We're just not sure about this"
  end

  def display_title(sba_app = nil)
    return title unless sba_app
    sba_app.is_adhoc? || sba_app.sub_info_request? ? sba_app.adhoc_question_title : title
  end

  def has_disqualifier?
    respond_to?(:disqualifier) && disqualifier.present?
  end
end
