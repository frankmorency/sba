class Questionnaire < ActiveRecord::Base
  include NameRequirements
  include Sectionable

  ADHOC_TYPES = %w(adhoc_text adhoc_attachment adhoc_text_and_attachment reconsideration) unless defined?(ADHOC_TYPES)
  ADHOC_TEXT, ADHOC_ATTACHMENT, ADDHOC_TEXT_AND_ATTACHMENT, RECONSIDERATION = ADHOC_TYPES unless defined?(ADHOC_TEXT)

  acts_as_paranoid
  has_paper_trail

  belongs_to :program

  has_many :every_section, -> { where("sba_application_id IS NULL") }, class_name: "Section", dependent: :destroy
  has_many :sections, -> { where("displayable = ? AND sba_application_id IS NULL", true).order(position: "asc") }
  has_many :templates, -> { where("sba_application_id IS NULL AND ancestry IS NULL") }, class_name: "Section::Template"
  has_many :review_sections, -> { where("sections.review_position IS NOT NULL AND sections.sba_application_id IS NULL AND sections.type != ? AND sections.type != ?", "Section::Template", "Section::Spawner").order(review_position: :asc) }, class_name: "Section"

  has_many :every_section_rule, -> { where(sba_application_id: nil) }, class_name: "SectionRule"
  has_many :section_rules, -> { where(sba_application_id: nil, template_root_id: nil) }
  has_many :section_rule_templates, -> { where("sba_application_id IS NULL AND template_root_id IS NOT NULL") }, class_name: "SectionRule"

  belongs_to :certificate_type
  has_many :sba_applications, dependent: :destroy
  has_many :evaluation_purposes, dependent: :destroy

  has_many :question_presentations, through: :non_dynamic_sections

  alias_method :children, :sections

  def self.check_am_i_eligible_results(params)
    # Load map of names to messages
    questionnaire = Questionnaire.find_by_name("am_i_eligible_v2")
    message_map = {}
    questionnaire.root_section.questions.map do |ques|
      message_map[ques.name.to_sym] = ques.question_presentations.last.helpful_info["reason"]
    end

    results_intro = {
      eighta: "<b>Based on the information you provided, you may not be eligible for the 8(a) BD Program:</b>",
      hubzone: "<b>Based on the information you provided, you may not be eligible for the HUBZone Program:</b>",
      wosb: "<b>Based on the information you provided, you may not be eligible for the WOSB Program:</b>",
      edwosb: "<b>Based on the information you provided, you may not be eligible for the EDWOSB Program:</b>",
    }

    # Build the results stringss
    @results = {}
    find_list_of_message_tags = {}
    message_strings = {}

    %w(wosb edwosb eighta hubzone).each do |program|
      find_list_of_message_tags[program.to_sym] = params[:eligibility_result][:eligibility_values][program.to_sym]["message_email"].split(",").reject { |element| element.empty? }
      array = find_list_of_message_tags[program.to_sym]
      array.each do |arr|
        if message_map.has_key? arr.to_sym
          if @results[program.to_sym].nil?
            @results[program.to_sym] = results_intro[program.to_sym]
          end
          @results[program.to_sym] += "#{message_map[arr.to_sym]}<br>"
        else
          raise "Someone passed a non valid value"
        end
      end
    end

    @results
  end

  def major_version
    version.primary_questionnaire_name
  end

  def version
    @q_version ||= QuestionnaireVersion.new(name)
  end

  #HAAAACK
  def adhoc_question_title
    sba_applications&.last&.adhoc_question_title
  end

  def has_agi?
    version.has_agi?
  end

  def is_not_version_of?(qname)
    !is_version_of?(qname)
  end

  def is_version_of?(qname)
    version.version_of?(qname)
  end

  def is_adhoc?
    version.is_adhoc?
  end

  def has_questionnaire_layout?
    version.has_questionnaire_layout?
  end

  def mpp_annual_report?
    version.mpp_annual_report?
  end

  def eight_a?
    version.eight_a?
  end

  def has_financial?
    version.has_financial?
  end

  def eight_a_master?
    version.eight_a_master?
  end

  def initial_or_annual_dvd?
    version.initial_or_annual_dvd?
  end

  def force_signature?
    version.force_signature?
  end

  def confirm_review?
    version.confirm_review?
  end

  def create_sections!(&block)
    QuestionnaireDSL.create! self, &block
  end

  def create_rules!(&block)
    QuestionnaireDSL.create! self, &block
  end

  def start_application(org, options = {})
    class_name = self.class.to_s.demodulize.split("Questionnaire").first

    if %w(EightAInitial EightAMigrated EntityOwnedInitial).include? class_name
      class_name = "SbaApplication::EightAMaster"
    elsif class_name == "ASMPPInitial"
      class_name = "SbaApplication::ASMPPMaster"
    else
      class_name = "SbaApplication::#{class_name}Application"
    end

    class_name.constantize.new(options.merge(organization: org, questionnaire: self, prerequisite_order: prerequisite_order))
  end

  def displays_disqualifiers_inline?
    version.inline_disqualifier?
  end
end
