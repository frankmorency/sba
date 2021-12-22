module ApplicationHelper
  def find_asset_path(asset)
    if ENV["CODE_DEPLOY"]
      "/assets/#{asset}"
    else
      asset_path(asset)
    end
  end

  def days_left_helper(days)
    if days > 1
      "#{days} days left"
    elsif days == 1
      "1 day left"
    elsif days == 0
      "No days left"
    elsif days == -1
      "1 day over"
    elsif days < -1
      "#{days.abs} days over"
    end
  end

  def app_under_reconsideration_link(app)
    if app.is_wosb? && app.is_annual?
      link_to app.link_label, app_read_only_path(app.app, current_organization)
    else
      link_to app.link_label, sba_application_application_dashboard_overview_index_path(sba_application_id: app.id)
    end
  end

  def get_dashboard_total(cases)
    count = 0
    cases.each_with_index do |kase|
      certificate = kase.certificates.select { |cert| cert["program"] == "EIGHT_A" }[0]
      next if (certificate.nil? || certificate.blank?)

      most_recent_review = { "id" => 0, "status" => "nothing" }
      certificate["reviews"].each do |review|
        most_recent_review = review if review["id"] > most_recent_review["id"]
      end

      if [certificate["case_owner_id"], certificate["current_reviewer_id"]].include?(current_user.id) && ["screening", "processing", "returned_with_15_day_letter"].include?(most_recent_review["status"])
        count += 1
      end
    end

    if count > 1
      "Showing #{count} cases"
    elsif count == 1
      "Showing 1 case"
    else
      "No assigned cases were found"
    end
  end

  def get_pagination_number(page_number, total, max_search_results)
    if total > max_search_results
      end_number = page_number.to_i * max_search_results
      start_number = end_number - max_search_results
      start_number += 1
      if end_number > total
        start_number.to_s + "-" + total.to_s + " of " + total.to_s + " results"
      else
        start_number.to_s + "-" + end_number.to_s + " of " + total.to_s + " results"
      end
    elsif total == 1
      total.to_s + " result"
    else
      total.to_s + " results"
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, "#", class: "add_fields", data: { id: id, fields: fields.gsub("\n", "") })
  end

  def all_cases_review_status(status)
    case status
    when "voluntary_withdrawn"
      "Voluntarily Withdrawn"
    when "appeal_intent"
      "Intent to Appeal"
    when 'pending_reconsideration_or_appeal'
      'Pending Appeal'
    when 'pending_reconsideration'
      'Ineligible'
    else
      status.titleize
    end
  end

  def link_to_new_eight_a_initial
    link_to CertificateType.find_by(name: "eight_a").initial_questionnaire.link_label, new_certificate_type_sba_application_url(certificate_type_id: "eight_a", application_type_id: SbaApplication::INITIAL)
  end

  def link_to_new_initial_app(program_name, num_of_results)
    # num_of_results param for link_to_new_initial_app() is used only for 'eight_a'. 0 is put in for other programs as a placeholder.
    link_to CertificateType.find_by(name: program_name).initial_questionnaire.link_label, new_certificate_type_sba_application_url(certificate_type_id: program_name, application_type_id: SbaApplication::INITIAL, num_of_results: num_of_results)
  end

  def workflow_image_path(klass)
    "/workflow/#{"#{klass.name.tableize.split("/").join("_")}_workflow"}.png"
  end

  def present(model, presenter_class = nil)
    klass = presenter_class || "#{model.class}Presenter".constantize
    presenter = klass.new(model, self)
    yield(presenter) if block_given?
    presenter
  end

  def is_vendor_or_contributor?(user)
    (can? :ensure_vendor, user) || (can? :ensure_contributor, user)
  end

  def is_vendor?(user)
    (can? :ensure_vendor, user)
  end

  def is_sba_user?(user)
    (can? :sba_user, user)
  end

  def show_bdmis_historic_data?(app, user)
    is_sba_user?(user) && app.migrated_from_bdmis?
  end

  def currently_with(app)
    reviewer = app.info_request? ? app.info_request_assigned_to : app.get_current_analyst_reviewer

    if app.returned_with_letter? || app.updates_needed? || app.awaiting_reconsideration_submission?
      "Firm"
    elsif reviewer
      role_name = ""
      role_name = reviewer.roles.first.name.split("_8a_")[1].upcase if reviewer.roles.count > 0
      "#{reviewer.name} (#{role_name})"
    else
      ""
    end
  end

  def strip_non_utf8(name)
    name.gsub(/[^[:word:]]+/, "").gsub(/\d+/, "")
  end

  def link_to_application_version(text, revision)
    if revision.is_current? || revision.is_reviewed?
      link_to_case_overview text, revision, :case_overview, revision.latest_review
    else
      link_to text, questionnaire_organization_sba_application_path(revision.questionnaire, revision.certificate.organization_id, revision), target: "_blank"
    end
  end

  def render_first_page(sba_application)
    if File.exists?(Rails.root.join("app", "views", "questionnaires", sba_application.questionnaire.name, "landing", "_#{sba_application.kind}.slim"))
      render partial: "questionnaires/#{sba_application.questionnaire.name}/landing/#{sba_application.kind}", locals: { questionnaire: sba_application.questionnaire }
    end
  end

  def render_question(question, options = {})
    if question.is_a?(String)
      question = @questions.find { |q| q.name == question }
    end

    render partial: "questions/edit", locals: { questionnaire: @questionnaire, question: question, answered_for: options[:answered_for], display: options[:display] }
  end

  def sortable(title, options = {})
    model = options[:model]
    model = model.constantize if model.is_a? String
    column = model.searchable_fields[:fields][title]
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, { sort: column, direction: direction, search_input: params[:search_input] }, { class: css_class }
  end

  def clear_search(title = "Clear")
    link_to title, { sort: nil, direction: nil }
  end

  def qid(name)
    q(name).id
  end

  def q(name)
    Question.find_by(name: name)
  end

  def render_section_header(questionnaire_name, section)
    if File.exists?(Rails.root.join("app", "views", "section", "headings", questionnaire_name, "_#{section.name}.slim"))
      render partial: "section/headings/#{questionnaire_name}/#{section.name}"
    end
  end

  def section_form(&block)
    form_tag section_path_helper(@sba_application, @section), id: "questionnaire_form", class: "section_form", method: "put", multipart: true do
      concat capture(&block)
      concat submit_tag @section.submit_text, class: "usa-button", id: "section_submit_button"
    end
  end

  def questionnaire_form_params(sba_application, section)
    if section.is_last?
      if sba_application.is_a?(SbaApplication::SubApplication) && section.is_a?(Section::SignatureSection)
        [sba_application, { url: sba_application_path(sba_application) }]
      elsif sba_application.is_a?(SbaApplication::SubApplication)
        [sba_application_path(sba_application), { method: "put" }]
      else
        [sba_application, { url: sba_application_path(sba_application) }]
      end
    else
      [section_path_helper(sba_application, section), { id: sba_application.questionnaire.name, method: "put" }]
    end
  end

  def section_path_helper(*args)
    edit = false
    section = nil
    app = nil

    if args.length == 1
      section = args.first
    elsif args.length == 3
      app, section, edit = args
    elsif args.length == 2 && [true, false].include?(args.last)
      section, edit = args
    elsif args.length == 2
      app, section = args
    end

    prefix = app ? "/sba_applications/#{app.id}" : ""
    "#{prefix}/questionnaires/#{section.questionnaire.name}/#{section.class_path}/#{section.name}#{"/edit" if edit}"
  end

  def percent_to_badge_modifier(percent)
    case percent
    when (0..64)
      return "--alert"
    when (65..79)
      return "--warn"
    when (80..100)
      return "--success"
    else
      return ""
    end
  end

  def status_to_badge_modifier(status)
    modifier = ""
    case status
    when "pending"
      modifier = "--info"
    when "graduated", "early_graduated", "expired"
      modifier = "--info-alt"
    when "ineligible", "terminated", "voluntary_withdrawn", "bdmis_rejected"
      modifier = "--alert"
    when "active"
      modifier = "--success"
    when "suspended"
      modifier = "--warn"
    end
    modifier
  end

  def display_status(workflow_state)
    ["voluntary_withdrawn"].include?(workflow_state) ? "Voluntarily Withdrawn" : workflow_state.titleize
  end

  def us_states
    [
      {
        name: "Alabama",
        code: "AL",
      },
      {
        name: "Alaska",
        code: "AK",
      },
      {
        name: "Arizona",
        code: "AZ",
      },
      {
        name: "Arkansas",
        code: "AR",
      },
      {
        name: "California",
        code: "CA",
      },
      {
        name: "Colorado",
        code: "CO",
      },
      {
        name: "Connecticut",
        code: "CT",
      },
      {
        name: "Delaware",
        code: "DE",
      },
      {
        name: "Florida",
        code: "FL",
      },
      {
        name: "Georgia",
        code: "GA",
      },
      {
        name: "Hawaii",
        code: "HI",
      },
      {
        name: "Idaho",
        code: "ID",
      },
      {
        name: "Illinois",
        code: "IL",
      },
      {
        name: "Indiana",
        code: "IN",
      },
      {
        name: "Iowa",
        code: "IA",
      },
      {
        name: "Kansas",
        code: "KS",
      },
      {
        name: "Kentucky",
        code: "KY",
      },
      {
        name: "Louisiana",
        code: "LA",
      },
      {
        name: "Maine",
        code: "ME",
      },
      {
        name: "Maryland",
        code: "MD",
      },
      {
        name: "Massachusetts",
        code: "MA",
      },
      {
        name: "Michigan",
        code: "MI",
      },
      {
        name: "Minnesota",
        code: "MN",
      },
      {
        name: "Mississippi",
        code: "MS",
      },
      {
        name: "Missouri",
        code: "MO",
      },
      {
        name: "Montana",
        code: "MT",
      },
      {
        name: "Nebraska",
        code: "NE",
      },
      {
        name: "Nevada",
        code: "NV",
      },
      {
        name: "New Hampshire",
        code: "NH",
      },
      {
        name: "New Jersey",
        code: "NJ",
      },
      {
        name: "New Mexico",
        code: "NM",
      },
      {
        name: "New York",
        code: "NY",
      },
      {
        name: "North Carolina",
        code: "NC",
      },
      {
        name: "North Dakota",
        code: "ND",
      },
      {
        name: "Ohio",
        code: "OH",
      },
      {
        name: "Oklahoma",
        code: "OK",
      },
      {
        name: "Oregon",
        code: "OR",
      },
      {
        name: "Pennsylvania",
        code: "PA",
      },
      {
        name: "Rhode Island",
        code: "RI",
      },
      {
        name: "South Carolina",
        code: "SC",
      },
      {
        name: "South Dakota",
        code: "SD",
      },
      {
        name: "Tennessee",
        code: "TN",
      },
      {
        name: "Texas",
        code: "TX",
      },
      {
        name: "Utah",
        code: "UT",
      },
      {
        name: "Vermont",
        code: "VT",
      },
      {
        name: "Virginia",
        code: "VA",
      },
      {
        name: "Washington",
        code: "WA",
      },
      {
        name: "West Virginia",
        code: "WV",
      },
      {
        name: "Wisconsin",
        code: "WI",
      },
      {
        name: "Wyoming",
        code: "WY",
      },
      {
        name: "District of Columbia",
        code: "DC",
      },
      {
        name: "Puerto Rico",
        code: "PR",
      },
      {
        name: "Guam",
        code: "GU",
      },
      {
        name: "American Samoa",
        code: "AS",
      },
      {
        name: "U.S. Virgin Islands",
        code: "VI",
      },
      {
        name: "Northern Mariana Islands",
        code: "MP",
      },
    ]
  end
end
