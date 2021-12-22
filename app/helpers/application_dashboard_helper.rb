module ApplicationDashboardHelper
  def display_assing_duty_stations?
    return false unless current_user.is_sba?
    return false unless @sba_application.is_a?(SbaApplication::MasterApplication)
    return false unless @sba_application.duty_stations.empty?
    return false unless @sba_application.certificate
    true
  end

  def generate_note_tags(application, cols = 3, async = true)
    html = ""

    unless application&.tags.nil?
      elements = application.tags
      num_elements = elements.count
      grouping = (num_elements / cols.to_f).ceil

      elements.in_groups_of(grouping, false).each do |section_array|
        html << '<div class="usa-width-one-third">'
        html << '<ul class="tag-selection-list">'
        section_array.each do |section|
          html << "<li>"
          if async
            html << check_box_tag("note-tags", section.name, false, id: "note-tag--#{section.name.parameterize}")
            html << label_tag("note-tag--#{section.name.parameterize}", section.name)
          else
            dash_version = section.name.tr(" ", "-")
            html << check_box_tag("note_tags[]", section.name, false, { id: "note-tag--#{dash_version}", class: "tag" })
            html << label_tag("note-tag--#{dash_version}", section.name)
          end
          html << "</li>"
        end
        html << "</ul>"
        html << "</div>"
      end
    end

    sanitize(html, tags: %w(div ul li input label), attributes: %w(class name checked id type for value))
  end

  def tag_list(application)
    html = ""

    unless application&.tags.nil?
      sections = application.tags
      sections.each do |section|
        html << "<li>"
        html << check_box_tag("category", section.name, false, id: section.name.downcase.parameterize("_"))
        html << label_tag(section.name.downcase.parameterize("_"), section.name)
        html << "</li>"
      end
    end

    sanitize(html, tags: %w(li input label), attributes: %w(type name id value for))
  end

  def dashboard_review_status(review)
    workflow_state = review.workflow_state
    state_labels = Review::EightA::STATE_LABELS
    return state_labels[workflow_state] if state_labels[workflow_state].present? && workflow_state != "screening"
    return "Intent to Appeal" if workflow_state == "appeal_intent"
    review.status
  end

  def analyst_reconsideration_section_display(app, section)
    if section.is_a?(Section::ReconsiderationSection) && app&.current_review && app&.last_reconsideration_section.id == section&.id
      link_to "Pending Appeal", "javascript:void(0);", { id: "#{section.name}_show_content" } if app&.current_review.pending_reconsideration_or_appeal?
      link_to "Intent to Appeal", "javascript:void(0);", { id: "#{section.name}_show_content" } if app&.current_review.appeal_intent?
      return "Appeal" if app&.current_review.appeal?
    end
    link_to section.title, "javascript:void(0);", { id: "#{section.name}_show_content" }
  end

  def construct_evaluation_history(model)
    html = ""
    evaluation_events = EvaluationHistory.for_evaluable_model model.id, model.class

    if evaluation_events.empty?
      html << "There are currently no items in the Recommendation History."
    else
      current_stage = ""
      evaluation_events.each_with_index do |evaluation, index|
        if current_stage != evaluation.stage
          current_stage = evaluation.stage

          html << "</ol>" unless index == 0
          html << '<h5 class="sba-c-recommendation-list-header">'
          html << evaluation.evaluation_stage_display
          html << "</h5>"
          html << '<ol class="sba-c-recommendation-list">'
        end
        html << "<li class='sba-c-recommendation-list__item sba-c-recommendation-list__item--#{evaluation.outcome}'>"
        html << '<div class="sba-c-recommendation-list__icon">'
        html << '<svg aria-hidden="true" class="sba-c-icon">'
        html << "<use href='/assets/landing-icons/sprite.svg#{evaluation.outcome_icon}' xmlns:xlink='http://www.w3.org/1999/xlink'></use>"
        html << "</svg>"
        html << "</div>"
        html << '<div class="sba-c-recommendation-list__content">'
        html << "<div class='sba-c-recommendation-list__recommendation'>#{evaluation.decision_display}</div>"
        html << "<div class='sba-c-recommendation-list__data'>#{evaluation.evaluator_name} (#{evaluation.evaluator_role}) on #{evaluation.created_at.strftime("%m/%d/%Y")}</div>"
        html << "</div>"
        html << "</li>"
      end
    end
    sanitize(html, tags: %w(h5 ol li div svg use), attributes: %w(class aria-hidden href xmlns:xlink))
  end
end
