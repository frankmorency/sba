module ReviewsHelper
  def set_review_sidenav(active)
    nav = {
        case_overview: '',
        question_review: '',
        financial_review: '',
        signature_review: '',
        determinations: '',
        revision_history: ''
    }
    nav[active] = 'usa-current'
    nav
  end

  def link_to_case_overview(text = 'Case overview', revision, active, review)
    css = set_review_sidenav(active)

    if revision.is_current?
      link_to text, new_sba_analyst_sba_application_review_path(revision), class: css[:case_overview]
    elsif revision.is_reviewed?
      link_to text, new_sba_analyst_sba_application_review_path(revision), class: css[:case_overview], target: '_blank'
    else
      raise "Cannot link to an old version of an application with no review: #{revision.id}"
    end
  end

  def link_to_question_review(revision, active, review = nil)
    css = set_review_sidenav(active)

    if revision.is_reviewed?
      link_to "Question review", new_sba_analyst_review_question_review_path(review), class: css[:question_review]
    else
      link_to "Question review", '#', class: 'notapplicable'
    end
  end

  def link_to_financial_review(revision, active, review, owners = nil)
    unless revision.is_reviewed? && !owners.blank?
      return link_to "Financial review", "#", class: 'notapplicable'
    end

    css = set_review_sidenav(active)

    html = ''
    html << link_to("Financial review", new_sba_analyst_review_financial_review_path(review, owner: owners.first.answered_for_id), class: css[:financial_review])

    html << '<ul class="usa-sidenav-sub_list">'
    owners.each do |partner|
      html << '<li>'
      html << link_to("#{partner.answered_for.first_name} #{partner.answered_for.last_name}", new_sba_analyst_review_financial_review_path(review, owner: partner.answered_for_id), class: css[:financial_review])
      html << '</li>'
    end

    html << '</ul>'
    html.html_safe
  end

  def link_to_signature_review(revision, active, review)
    css = set_review_sidenav(active)

    if revision.is_reviewed?
      link_to 'Signature review', new_sba_analyst_review_signature_review_path(review), class: css[:signature_review]
    else
      link_to 'Signature review', '#', class: 'notapplicable'
    end
  end

  def link_to_determination(revision, active, review)
    css = set_review_sidenav(active)

    if revision.is_reviewed? && review && review.determination_id
      link_to 'Determination', edit_sba_analyst_review_determination_path(review, review.determination_id), class: css[:determinations]
    elsif revision.is_reviewed? && review
      link_to 'Determination', new_sba_analyst_review_determination_path(review), class: css[:determinations]
    else
      link_to 'Determination', '#', class: 'notapplicable'
    end
  end

  def link_to_revision_history(revision, active, review)
    css = set_review_sidenav(active)

    if revision.is_reviewed?
      link_to 'Revision history', sba_analyst_review_sba_application_revisions_path(review, revision.current_sba_application), class: css[:revision_history]
    else
      link_to 'Revision history', sba_analyst_sba_application_revisions_path(revision.current_sba_application), class: css[:revision_history]
    end
  end

  def current_reviewer_dropdown(review, analysts, ca)
    unless review.current_assignment.id.nil?
      if review.determination_made?
        ca.select :reviewer_id, options_for_select(analysts, "#{review.current_assignment.reviewer_id.to_s}"), disabled: true
      else
        ca.select :reviewer_id, options_for_select(analysts, "#{review.current_assignment.reviewer_id.to_s}")
      end
    else
      ca.select :reviewer_id, options_for_select(analysts, "#{current_user.id.to_s}")
    end
  end

  def owner_dropdown(review, analysts, ca)
    unless review.current_assignment.id.nil?
      if review.determination_made?
        ca.select :owner_id, options_for_select(analysts, "#{review.current_assignment.owner_id.to_s}"), {}, disabled: true
      else
        ca.select :owner_id, options_for_select(analysts, "#{review.current_assignment.owner_id.to_s}"), {}, disabled: !(can? :change_owner_after_review_start, current_user)
      end
    else
      ca.select :owner_id, options_for_select(analysts, "#{current_user.id.to_s}")
    end
  end

  def supervisor_dropdown(review, analysts, ca)
    unless review.current_assignment.id.nil?
      if review.determination_made?
        ca.select :supervisor_id, options_for_select(analysts, "#{review.current_assignment.supervisor_id.to_s}"), {}, disabled: true
      else
        ca.select :supervisor_id, options_for_select(analysts, "#{review.current_assignment.supervisor_id.to_s}"), {}, disabled: !(can? :change_supervisor_after_review_start, current_user)
      end
    else
      ca.select :supervisor_id, options_for_select(analysts)
    end
  end

  def question_review_display(q)
    if q.question.question_type.is_a?(QuestionType::Boolean)
      render partial: 'sba_analyst/question_reviews/question_display_boolean', locals: {q:q}
    elsif q.question.question_type.is_a?(QuestionType::Null)
      render partial: 'sba_analyst/question_reviews/question_display_no_value', locals: {q:q}
    else
      render partial: 'sba_analyst/question_reviews/question_display_under_text', locals: {q:q}
    end
  end

  def next_analyst_review_step(current_step, review, ordered_answered_for_ids = nil, current_answered_for_id = nil)
    case current_step
      when 'sba_analyst/question_reviews'
        if review.certificate_type_name == 'edwosb' && !ordered_answered_for_ids.empty?
          new_sba_analyst_review_financial_review_path(review, owner: ordered_answered_for_ids.first)
        else
          new_sba_analyst_review_signature_review_path(review)
        end
      when 'sba_analyst/financial_reviews'
        if (ordered_answered_for_ids.nil? || current_answered_for_id.nil?)
          :back
        elsif ordered_answered_for_ids.last == current_answered_for_id
          new_sba_analyst_review_signature_review_path(review)
        else
          old_index = ordered_answered_for_ids.find_index(current_answered_for_id)
          new_sba_analyst_review_financial_review_path(review, owner: ordered_answered_for_ids[old_index+1])
        end
      when 'sba_analyst/signature_reviews'
        new_sba_analyst_review_determination_path(review)
      when 'sba_analyst/determinations'
        :back
      else
        :back
    end
  end

  def next_in_chain(user)
    case user.roles.first.name
      when 'sba_analyst_8a_cods'
        ['sba_supervisor_8a_cods', 'CODS', 'a Supervisor']
      when 'sba_supervisor_8a_cods'
        ['sba_supervisor_8a_hq_program', 'HQ_PROGRAM', 'a Director']
      when 'sba_supervisor_8a_hq_program'
        ['sba_supervisor_8a_hq_aa', 'HQ_AA', 'an Associate Administrator']
      else
        ['sba_supervisor_8a_cods', 'CODS', 'a Supervisor']
    end
  end
  
  def forward_this_case_options(form_object, review = nil)
    return aa_review_forward_options(form_object) if review&.type && review.type == 'Review::AdverseAction'
    default_forward_options(form_object)
  end

  def default_forward_options(form_object)
    options = next_in_chain(current_user)
    users = User.where("roles_map::jsonb ? '#{options[1]}' ").select{ |u| u.roles.include? Role.find_by_name("#{options[0]}") }

    html = ''
    html << '<fieldset class="questions">'
    html << "<h4>Please select #{options[2]}</h4>"
    html << '<ul class="usa-unstyled-list" id="response">'
    users.each do |user|
      html << '<li>'
      html << form_object.radio_button('individual_id', user.id, id: "reassigned_to_#{user.id}", class: "radio-btn")
      html << label_tag("reassigned_to_#{user.id}", user.name)
      html << '</li>'
    end
    html << '</ul>'
    html << '</fieldset>'

    html.html_safe
  end

  def aa_review_forward_options(form_object)
    voluntary_withdrawal_recommended = params['recommendation']['recommend_eligible'] == "voluntary_withdrawal_recommended"
    html = ''

    if voluntary_withdrawal_recommended
      users = User.where("roles_map::jsonb ? 'DISTRICT_OFFICE_DIRECTOR' ").select{ |u| u.roles.include? Role.find_by_name("sba_director_8a_district_office") }
      html << user_list_two_column(form_object, users, "District Office Directors")

      users = User.where("roles_map::jsonb ? 'DISTRICT_OFFICE_DEPUTY_DIRECTOR' ").select{ |u| u.roles.include? Role.find_by_name("sba_deputy_director_8a_district_office") }
      html << user_list_two_column(form_object, users, "District Office Deputy Directors")
    else
      unit_title = BusinessUnit.find_by(name: 'DISTRICT_OFFICE').title
      users = User.where("roles_map::jsonb ? 'DISTRICT_OFFICE' ").select{ |u| u.roles.include? Role.find_by_name("sba_supervisor_8a_district_office") }
      html << user_list_two_column(form_object, users, unit_title)

      unit_title = BusinessUnit.find_by(name: 'HQ_PROGRAM').title
      users = User.where("roles_map::jsonb ? 'HQ_PROGRAM' ").select{ |u| u.roles.include? Role.find_by_name("sba_supervisor_8a_hq_program") }
      html << user_list_two_column(form_object, users, unit_title)

      unit_title = BusinessUnit.find_by(name: 'HQ_AA').title
      users = User.where("roles_map::jsonb ? 'HQ_AA' ").select{ |u| u.roles.include? Role.find_by_name("sba_supervisor_8a_hq_aa") }
      html << user_list_two_column(form_object, users, unit_title)

      unit_title = BusinessUnit.find_by(name: 'HQ_CE').title
      users = User.where("roles_map::jsonb ? 'HQ_CE' ").select{ |u| u.roles.include? Role.find_by_name("sba_supervisor_8a_hq_ce") }
      html << user_list_two_column(form_object, users, unit_title)
    end

    html.html_safe
  end

  def user_list_two_column(form_object, users, unit_title)
    html = ''
    html << "<h4>#{unit_title}</h4>"
    html << '<div style="width:75%">'
    users.each do |user|
      html << '<div style="float:left;width:50%">'
      html << form_object.radio_button('individual_id', user.id, id: "reassigned_to_#{user.id}", class: "radio-btn")
      html << label_tag("reassigned_to_#{user.id}", user.name)
      html << '</div>'
    end
    html << '</div>'
    html << '<div style="clear: both;">&nbsp;</div>'
    html.html_safe
  end

end
