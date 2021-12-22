class QuestionnaireVersion
  QUESTIONNAIRE_VERSIONS = {
      'adverse_action_blank' => %w(adverse_action_blank),
      'adhoc_attachment' => %w(adhoc_attachment),
      'adhoc_text' => %w(adhoc_text),
      'adhoc_text_and_attachment' => %w(adhoc_text_and_attachment),
      'am_i_eligible' => %w(am_i_eligible am_i_eligible_v2),
      'asmpp_eligibility' => %w(asmpp_eligibility),
      'asmpp_initial' => %w(asmpp_initial),
      'asmpp_mentor' => %w(asmpp_mentor),
      'asmpp_protege' => %w(asmpp_protege),
      'bdmis_archive' => %w(bdmis_archive),
      'edwosb' => %w(edwosb edwosb_v_one edwosb_v_two edwosb_v_three),
      'eight_a' => %w(eight_a),
      'eight_a_annual_business_development' => %w(eight_a_annual_business_development),
      'eight_a_annual_control' => %w(eight_a_annual_control),
      'eight_a_annual_review' => %w(eight_a_annual_review),
      'eight_a_annual_review_eligibility' => %w(eight_a_annual_review_eligibility),
      'eight_a_annual_review_ownership' => %w(eight_a_annual_review_ownership),
      'eight_a_business_ownership' => %w(eight_a_business_ownership),
      'eight_a_business_partner' => %w(eight_a_business_partner eight_a_business_partner_v_two),
      'eight_a_business_partner_annual_review' => %w(eight_a_business_partner_annual_review),
      'eight_a_character' => %w(eight_a_character),
      'eight_a_company' => %w(eight_a_company),
      'eight_a_control' => %w(eight_a_control),
      'eight_a_disadvantaged_individual' => %w(eight_a_disadvantaged_individual eight_a_disadvantaged_individual_v_two eight_a_disadvantaged_individual_v_three),
      'eight_a_disadvantaged_individual_annual_review' => %w(eight_a_disadvantaged_individual_annual_review),
      'eight_a_eligibility' => %w(eight_a_eligibility eight_a_eligibility_v_two),

      'eight_a_info_request' => %w(eight_a_info_request),
      'eight_a_initial' => %w(eight_a_initial),
      'eight_a_migrated' => %w(eight_a_migrated),
      'eight_a_potential_for_success' => %w(eight_a_potential_for_success),
      'eight_a_spouse' => %w(eight_a_spouse eight_a_spouse_v_two),
      'eight_a_spouse_annual_review' => %w(eight_a_spouse_annual_review),
      'mpp' => %w(mpp),
      'mpp_annual_renewal' => %w(mpp_annual_renewal),
      'reconsideration' => %w(reconsideration),
      'reconsideration_attachment' => %w(reconsideration_attachment),
      'wosb' => %w(wosb wosb_v_one),

      # for test
      'dynamic_q' => %w(dynamic_q),
      'basic_q' => %w(basic_q),
      'wosb_q' => %w(wosb_q),
      'mpp_q' => %w(mpp_q)
  }
  attr_reader :name

  def versions
    QUESTIONNAIRE_VERSIONS.values.flatten.uniq
  end

  def initialize(name)
    unless versions.include? name
      raise "The questionnaire '#{name}' has not been added to the QuestionnaireVersion model!"
    end

    @name = name
  end

  def primary_questionnaire_name
    QUESTIONNAIRE_VERSIONS.each do |k, v|
      if v.include?(name)
        return k
      end
    end

    raise "The questionnaire '#{qname}' has not been added to QUESTIONNAIRE_VERSIONS in QuestionnaireVersion" unless versions_include?(qname)
  end

  def version_of_any?(list)
    list.each do |qname|
      return true if version_of?(qname)
    end

    false
  end

  def version_of?(qname)
    raise "The questionnaire '#{qname}' has not been added to QUESTIONNAIRE_VERSIONS in QuestionnaireVersion" unless versions_include?(qname)

    if qname.kind_of?(Array)
      qname.include? name
    else
      QUESTIONNAIRE_VERSIONS[qname].include? name
    end
  end

  def info_request?
    version_of_any? %w(eight_a_info_request) # add to this list for new info requests
  end

  def has_agi?
    has_financial? && ! version_of_any?(%w(eight_a_disadvantaged_individual eight_a_spouse))
  end

  def mpp_annual_report?
    version_of? 'mpp_annual_renewal'
  end

  def force_signature?
    version_of_any?(%w(eight_a_spouse eight_a_disadvantaged_individual)) || name == "submit_without_certificate" # looks like a hack...
  end

  def has_questionnaire_layout?
    ! version_of_any? %w(eight_a_eligibility eight_a_annual_review_eligibility)
  end

  def eight_a_master?
    version_of? 'eight_a'
  end

  # this looks light...
  def eight_a?
    version_of_any? %w(eight_a_initial eight_a_eligibility eight_a_disadvantaged_individual eight_a_spouse eight_a_business_ownership eight_a_potential_for_success eight_a_business_partner eight_a_control eight_a_character)
  end

  def initial_or_annual_dvd?
    version_of_any? %w(eight_a_disadvantaged_individual eight_a_disadvantaged_individual_annual_review)
  end

  def inline_disqualifier?
    version_of_any? %w(eight_a_eligibility eight_a_annual_review_eligibility asmpp_eligibility)
  end

  def has_financial?
    version_of_any? %w(eight_a_spouse eight_a_disadvantaged_individual eight_a_disadvantaged_individual_annual_review eight_a_spouse_annual_review)
  end

  def no_review_confirmation?
    version_of_any? %w(eight_a_control eight_a_eligibility eight_a_potential_for_success eight_a_character eight_a_business_ownership adhoc_text_and_attachment adhoc_attachment adhoc_text)
  end

  def is_adhoc?
    version_of_any?(Questionnaire::ADHOC_TYPES)
  end

  def confirm_review?
    ! no_review_confirmation?
  end

  def versions_include?(qname)
    if qname.kind_of?(Array)
      (QUESTIONNAIRE_VERSIONS.keys & qname).present?
    else
      QUESTIONNAIRE_VERSIONS.keys.include? qname
    end
  end
end