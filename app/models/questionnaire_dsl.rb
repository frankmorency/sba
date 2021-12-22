class QuestionnaireDSL
  attr_accessor :parent_sections, :questionnaire, :top, :context

  def initialize(questionnaire, context = :create)
    @next_review_position = 0
    @context = context
    @questionnaire = questionnaire
    @parent_sections = []
    @top = nil
    @errors = []
  end

  def self.create!(questionnaire, &block)
    builder = new(questionnaire)

    Questionnaire.transaction do
      builder.instance_eval(&block)

      if builder.top.is_a? Section::Root
        questionnaire.update_attribute(:root_section_id, builder.top.id)
      end
    end

    builder.top
  end

  def self.update!(questionnaire = nil, &block)
    builder = new(questionnaire, :update)

    Questionnaire.transaction do
      builder.instance_eval(&block)
    end

    builder.top
  end

  %w(root adhoc_questionnaires_section composite_question_section repeating_question_section signature_section review_section contributor_section question_section template real_estate_section personal_summary personal_privacy).each do |meth|
    define_method(meth) do |name, position, options = {}, &block|
      add_section("Section::#{meth.camelize}".constantize, options.merge(name: name, position: position), &block)
    end
  end

  def template_rules(root, &block)
    @template_root = @questionnaire.templates.find_by(name: root)
    instance_eval(&block)
    @template_root = nil
  end

  def section_rule(from_name, to_name, expression = nil)
    from = @questionnaire.every_section.find_by(name: from_name)
    to = @questionnaire.every_section.find_by(name: to_name)

    if to.nil? && !to_name.blank? || from.nil? && !from_name.blank?
      raise "section_rule: unable to find section: from - '#{from_name}' (#{from}) to - '#{to_name}' (#{to}) for questionnaire: #{@questionnaire.name}"
    end

    if expression.is_a?(Hash) && expression[:klass] == 'MultiPath'
      SectionRule.create! questionnaire: @questionnaire, from_section_id: from.id, to_section_id: to.id, terminal_section_id: to.id, expression: expression, template_root: @template_root, is_multi_path_template: true
    else
      SectionRule.create! questionnaire: @questionnaire, from_section_id: from.try(:id), to_section_id: to.try(:id), expression: expression, template_root: @template_root
    end
  end

  def spawner(name, position, options = {}, &block)
    template = @questionnaire.templates.find_by(name: options.delete(:template_name))
    add_section(Section::Spawner, options.merge(name: name, position: position, template: template), &block)
  end

  def method_missing(m, *args)
    super unless QuestionType::TYPES.include? m.to_s

    add_question m, *args
  end

  def question(question_name, position, options = {})
    question = Question.get(question_name)
    positive_responses  = options.delete(:positive_response) || {}
    decider = options.delete(:decider)

    add_question_prez(decider, question_name, options, position, positive_responses, question)
  end

  def update_question(label, title)
    raise "Cannot update in a create context!" unless context == :update

    question = Question.get!(label)
    question.update_attribute(:title, title)
  end

  private

  def add_question(type_name, name, position, options = {})
    question_type      = QuestionType.get(type_name)
    positive_responses  = options.delete(:positive_response) || {}
    decider = options.delete(:decider)

    raise "Question Type not found #{type_name}" unless question_type

    question = Question.get(name)
    unless question
      attrs = { name: name, question_type: question_type, title: options[:title] || "#{name.split('_').join(' ')}?", possible_values: options[:possible_values], sub_questions: options[:sub_questions], multi: options[:multi], strategy: options[:strategy]}

      if question.respond_to? :prepopulate
        attrs[:prepopulate] = options[:prepopulate]
      end

      if options.dig(:title_wrapper_tag).present?
        attrs[:title_wrapper_tag] = options[:title_wrapper_tag]
      end

      question = Question.new attrs
    end

    if options[:document_types]
      Array.wrap(options[:document_types]).each do |doc_type|
        dt = DocumentType.find_by(name: doc_type)
        question.document_type_questions << DocumentTypeQuestion.new(document_type_id: dt.id)
      end
    end

    add_question_prez(decider, name, options, position, positive_responses, question)
  end

  def add_question_prez(decider, name, options, position, positive_responses, question)
    positive_responses.each do |key, value|
      question.applicable_questions.new positive_response: value, evaluation_purpose: EvaluationPurpose.get(key)
    end

    last_section = parent_sections.last
    if last_section.respond_to?(:review_position) && last_section.review_position.blank?
      last_section.update_attribute(:review_position, @next_review_position += 1)
    end

    question_prez = question.question_presentations.new section: last_section, position: position, helpful_info: options[:helpful_info], validation_rules: options[:validation_rules], question_override_title: options[:question_override_title]
    if options[:disqualifier]
      question_prez.build_disqualifier(options[:disqualifier])
    end
    if options[:repeater_label] || options[:maximum] || options[:minimum]
      question_prez.repeater_label = options[:repeater_label]
      question_prez.maximum = options[:maximum]
      question_prez.minimum = options[:minimum]
    end
    question.save!

    if decider && last_section.is_a?(Section::Spawner)
      repeat = last_section.repeat
      repeat[:decider] = name
      last_section.update_attribute(:repeat, repeat)
    end
  end

  def master_application_section(name, position, options = {}, &block)
    options.delete(:first)
    section = Section::MasterApplicationSection.new
    section.questionnaire = questionnaire
    section.attributes = options.merge(name: name, position: position, is_completed: false, title: options[:title] || name.titleize, parent: parent_sections.last)
    section.save!

    questionnaire.update_attribute(:first_section_id, section.reload.id)

    parent_sections.push section

    if block_given?
      instance_eval(&block)
    end

    @top = parent_sections.pop
  end

  def sub_questionnaire(name, position, options = {})
    section = Section::SubQuestionnaire.new
    q = options.delete(:questionnaire)

    if Section.column_names.include?('status')
      section.prescreening = options.delete(:prescreening)
      section.status = options.delete(:status)
    end

    section.questionnaire = questionnaire
    section.attributes = options.merge(name: name, position: position, is_completed: false, title: options[:title] || name.titleize, parent: parent_sections.last)
    section.sub_questionnaire = Questionnaire::SubQuestionnaire.find_by(name: q || name)
    section.save!
  end

  def add_section(klass, options = {}, &block)
    first = options.delete(:first)
    options.delete(:current_sba_application_id)

    section = klass.new
    section.questionnaire = questionnaire
    if options[:sub_questionnaire]
      n = options.delete(:sub_questionnaire)
      section.sub_questionnaire = Questionnaire::SubQuestionnaire.find_by(name: n)
      raise n.inspect unless section.sub_questionnaire
    end
    section.attributes = options.merge(is_completed: false, title: options[:title] || options[:name].titleize, parent: parent_sections.last, validation_rules: options[:validation_rules])
    section.save!

    parent_sections.push section

    if first
      @questionnaire.update_attribute(:first_section_id, parent_sections.last.id)
    end

    if klass == Section::Root
      @questionnaire.update_attribute(:root_section_id, parent_sections.last.id)
    end

    if block_given?
      instance_eval(&block)
    end
    @top = parent_sections.pop
  end
end
