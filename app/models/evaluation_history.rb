class EvaluationHistory < ActiveRecord::Base
  POSITIVE_EVENTS = %w(eligible retain)
  NEGATIVE_EVENTS = %w(ineligible recommended_early_graduation recommended_termination recommended_voluntary_withdrawal finalize_termination finalize_early_graduation finalize_voluntary_withdrawal termination_recommended voluntary_withdrawal_recommended early_graduation_recommended)
  CATEGORIES = %w(determination recommendation)

  acts_as_paranoid
  # has_paper_trail

  belongs_to :evaluable, polymorphic: true
  belongs_to :evaluator, class_name: "User"

  validates :category, :value, :stage, :evaluator_id, presence: true

  def self.for_evaluable_model(model_id, model_type)
    where(evaluable_id: model_id).where(evaluable_type: model_type).order(created_at: :desc)
  end

  def record_evaluation_event(model, evaluator, category, value)
    stage = determine_evaluation_stage model
    self.update({ evaluable_id: model.id, evaluable_type: model.class, evaluator_id: evaluator.id, category: category, value: value, stage: stage })
    self.save
  end

  def evaluation_stage_display
    case stage
    when "annual"
      "Annual Review"
    when "initial"
      "Initial Application"
    when "adverse_action"
      "Adverse Action"
    else
      "Reconsideration submitted #{created_at.strftime("%m/%d/%Y")}"
    end
  end

  def decision_display
    case value
    when "termination_recommended", "voluntary_withdrawal_recommended", "early_graduation_recommended"
      "#{value.gsub("_recommended", "").titleize} (Recommended)"
    when "recommended_early_graduation", "recommended_termination", "recommended_voluntary_withdrawal"
      "#{value.gsub("recommended_", "").titleize} (Recommended)"
    when "finalize_termination", "finalize_early_graduation", "finalize_voluntary_withdrawal"
      if evaluable_type == "Review::AdverseAction"
        "#{value.gsub("finalize_", "").titleize} (Approved)"
      else
        "#{value.gsub("finalize_", "").titleize} (Determination)"
      end
    else
      "#{value.titleize} #{category_display}"
    end
  end

  def category_display
    case category
    when "recommendation"
      "(Recommended)"
    when "determination"
      "(#{category.titleize})"
    else
      ""
    end
  end

  def evaluator_name
    evaluator&.name
  end

  def evaluator_role
    !/(supervisor|director)/.match(evaluator&.roles&.first&.name).nil? ? "Supervisor" : "Analyst"
  end

  def outcome
    case category
    when "determination"
      return "final-positive" if POSITIVE_EVENTS.include?(value)
      return "final-negative" if NEGATIVE_EVENTS.include?(value)
    when "recommendation"
      return "positive" if POSITIVE_EVENTS.include?(value)
      return "negative" if NEGATIVE_EVENTS.include?(value)
    else
      ""
    end
  end

  def outcome_icon
    return "#check-circle" if POSITIVE_EVENTS.include?(value)
    return "#times-circle" if NEGATIVE_EVENTS.include?(value)
  end

  private

  def evaluator
    User.find_by_id(evaluator_id)
  end

  def determine_evaluation_stage(application)
    return "adverse_action" if application.is_really_a_review?
    return application.last_reconsideration_section.name if application.has_reconsideration_sections?
    return "initial" if application.is_initial?
    return "annual" if application.is_annual?
  end
end
