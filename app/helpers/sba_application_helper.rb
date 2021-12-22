module SbaApplicationHelper
  def app_read_only_path(app, org)
    questionnaire_organization_sba_application_path(app.questionnaire, org.id, app.id)
  end

  def ad_hoc_application_answer_content_link section
    link_to section.sub_application.adhoc_question_title, "javascript:void(0);", id: "#{section.name}_show_content"
  end

  def sub_application_answer_content_link sub_application_section
    link_to sub_application_section.title, "javascript:void(0);", id: "#{sub_application_section.name}_show_content"
  end

  def sub_application_edit_link sub_application_section
    sub_app = sub_application_section.sub_application
    current_section = sub_app.current_section || sub_app.first_section
    section_type = current_section.class.to_s.demodulize.underscore
    url = "edit_sba_application_questionnaire_#{section_type}_path"

    link_to sub_application_section.title, send(url, sub_app.id, sub_app.questionnaire.name, current_section.name)
  end

  def submission_guidance(sba_application)
    if sba_application.current_review && sba_application.current_review.appeal_intent?
      {title: "Submit your appeal to SBA's Office of Hearing & Appeals (OHA)", text: "You are required to mail or email your appeal directly to OHA and SBA through the instructions in your decline letter or in the appeals section on this page."}
    elsif sba_application.has_reconsideration_sections? && sba_application.all_reconsiderations_complete?
      {title: 'Your reconsideration is ready to submit.', text: "You must click \"sign and submit\" to submit your reconsideration. After you submit, you will not be able to make changes to your reconsideration request."}
    elsif sba_application.returned?
      {title: 'Please make changes found within the Deficiency Letter.', text: 'Please make changes found within the Deficiency Letter, which can be found in your Messages tab. Once updated, click sign and submit.'}
    else
      {title: 'Your application package is ready to submit!', text: 'All sections for you and your contributors are complete. Once you submit your application package, you will not be able to make changes.'}
    end
  end

  def masthead_local_nav
    html = ''

    html << '<ul class="usa-nav-primary usa-accordion">'

    html << '<li>'
    html << link_to("Application", new_sba_analyst_sba_application_review_path(sba_application_id: @sba_application.id), class: "usa-nav-link current")
    html << '</li>'

    html << '<li>'

    html << button_tag(type: 'button', class:"usa-accordion-button.usa-nav-link", aria: {controls: "side-nav-3", expanded: "false"}) do
      content_tag(:span, "Documents")
    end

    html << '<ul aria-hidden="true" class="usa-nav-submenu" id="side-nav-3">'

    html << '<li>'
    html << link_to("Firm Documents", "#", class: "usa-nav-link")
    html << '</li>'

    html << '<li>'
    html << link_to("Analyst Documents", "#", class: "usa-nav-link")
    html << '</li>'

    html << '</ul>'
    html << '</li>'

    unless ((can? :ensure_vendor, current_user) || (can? :ensure_contributor, current_user))
      html << '<li>'
      html << link_to("#", class: "usa-nav-link") do
        content_tag(:span, "Notes")
      end
      html << '</li>'

      html << '<li>'
      html << link_to("#", class: "usa-nav-link") do
        content_tag(:span, "Messages")
      end
      html << '</li>'

      html << '<li>'
      html << link_to("#", class: "usa-nav-link") do
        content_tag(:span, "Activity Log")
      end
      html << '</li>'
    end

    html << '</ul>'
    html.html_safe
  end

end
