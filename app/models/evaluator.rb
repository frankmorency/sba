class Evaluator
  attr_accessor :user, :klass, :identifier, :field, :operation, :values, :app_id

  attr_reader   :field_value, :object

  def self.eval_expression(rule, expression, app_id)
    result = false
    case expression.try(:[], 'klass')
      when 'MultiPath'
        result = Evaluator::MultiPath.new(rule, expression, app_id).update_section_rules
      when 'Organization'
        result = Evaluator.new(app_id: app_id, klass: SbaApplication.find(app_id).organization, field: expression['field'], operation: expression['operation'], value: expression['value']).true?
      when 'Answer'
        result = Evaluator.new(app_id: app_id, user: @user, klass: 'Answer', identifier: expression['identifier'], operation: expression['operation'], value: expression['value']).true?
      else
        result = true
    end
    result
  end

  #Evaluator.new(klass: organization, field: 'business_type', operation: 'not_equal', value: ['corp', 's-corp']).true?
  #Evaluator.new(user: current_user, klass: 'Answer', identifier: 6, value: 'yes').true?
  def initialize(options = {})
    options = options.with_indifferent_access

    @user = options[:user]
    # TODO: Ensure app is within user's orgs
    @application = SbaApplication.find(options[:app_id])
    @identifier = options[:identifier]
    @field = options[:field] || 'response'
    @values = Array.wrap(options[:value])
    @operation = options[:operation] || 'equal'

    if options[:klass] == 'Answer'
      @object = @application.answers.joins(:question).find_by('questions.name = ?', identifier)

      if @object.nil?
        raise "Expecting answer to question '#{identifier}' on application ##{@application.id} but found none"
      end
    else
      @object = options[:klass]
    end

    unless object.respond_to?(field)
      raise "Expected #{@object} to respond to the field #{field}"
    end

    if [:response, 'response'].include? @field
      @field_value = object.display_value
    else
      @field_value = object.send(field)
    end
  end

  def true?
    operation == 'not_equal' ? not_equal? : equal?
  end

  def equal?
    values.include? field_value
  end

  def not_equal?
    values.exclude? field_value
  end
end
