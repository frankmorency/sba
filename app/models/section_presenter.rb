class SectionPresenter
  attr_accessor :section, :current, :css_classes

  delegate   :children, :has_children?, :title, :questionnaire, :class_path, :name, :applicable?, :complete?, :question_presentations, :is_viewable?, to: :section

  def initialize(section, current)
    @section = section
    @current = current

    determine_css
  end

  def to_css
    @css_classes.join(' ')
  end

  def not_applicable?
    @css_classes.include? 'notapplicable'
  end

  def empty_or_viewable?
    (!question_presentations.empty? || is_viewable?) && ! (@css_classes & %w(usa-current completed notapplicable)).empty?
  end

  private

  def determine_css
    @css_classes = []

    if complete?
      @css_classes << 'completed'
    else

    end

    # this is odd because the docs for ancestry say that descendants is a single sql query
    # nevertheless it causes a slow down
    if current == name #|| section.descendants.map(&:name).include?(current)
      @css_classes << 'usa-current'
    end

    unless applicable?
      @css_classes << 'notapplicable'
    end
  end
end