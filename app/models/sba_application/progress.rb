require 'new_relic/agent/method_tracer'

class SbaApplication::Progress
  attr_accessor :user, :next_section, :skip_info, :sba_application, :section

  def self.advance!(app, user, section, answer_params = [])
    progress = new(app, user, section, answer_params)
    progress.update!
    [ progress.next_section, progress.skip_info ]
  end

  def initialize(app, user = nil, section = nil, answer_params = [])
    @sba_application, @user, @section, @answers = app, user, section, answer_params
    raise Error::DataManipulation.new("Trying to access another user's app #{@sba_application.id} #{@user.id}") if @user && @sba_application.organization_id != @user.one_and_only_org.id
    @tmp_cache = {}
  end

  def update!
    ActiveRecord::Base.transaction do
      user.save! if user.changed?

      @next_section, @skip_info = @section.next_section(user, sba_application.id)
      update_progress section, next_section, skip_info
      sba_application.current_section = next_section
      sba_application.save!

      section.update_progress(@answers, sba_application)
    end

    update_parents
  end

  def update_skip_info!
    @tmp_cache = {}

    # Find paths for each section
    @sba_application.sections.where.not(type: 'Section::Template').order('id desc').each do |section|
      Rails.logger.debug "AMX: Finding path for section #{section.name} (#{section.id})"
      find_possible_path(section.id)
    end

    # Identify not applicable sections for each rule
    @sba_application.section_rules.where(template_root_id: nil).order('id desc').each do |rule|
      Rails.logger.debug "AMX: Identify NA sections for rule : from: #{rule.from_section.try(:name)} (#{rule.from_section_id}) to : #{rule.to_section.try(:name)} (#{rule.to_section_id})"
      from = get_possible_path(rule.from_section_id)
      to = get_possible_path(rule.to_section_id)
      notapplicable = from - to - [@sba_application.sections.find(rule.from_section_id).name]
      applicable = to
      rule.skip_info = { notapplicable: notapplicable, applicable: applicable }
      rule.save!
    end

    Rails.logger.debug "AMX: Cache: #{@tmp_cache}"
    @tmp_cache = {}
  end

  private

  def update_progress(completed_section, current_section, skip_info)
    update_sections [completed_section.name], true, nil
    unless skip_info.nil?
      update_sections skip_info['notapplicable'] -= [current_section], nil, false
      update_sections skip_info['applicable'], nil, true
    end
  end

  def update_parents
    @sba_application.update_parents!
  end

  def update_sections(sections, is_complete = nil, is_applicable = nil)
    sections.each do |section|
      section_hdl = @sba_application.sections.find_by(name: section)
      section_hdl.is_completed = is_complete unless is_complete.nil?
      section_hdl.is_applicable = is_applicable unless is_applicable.nil?
      section_hdl.save!
    end
  end

  def find_possible_path(section_id)
    return [] unless section_id

    if @tmp_cache[section_id]
      Rails.logger.debug "AMX:   find_possible_path for section id from cache : #{section_id}"
      @tmp_cache[section_id]
    else
      Rails.logger.debug "AMX:   find_possible_path for section id : #{section_id}"
      collection = [@sba_application.sections.find(section_id).name]

      paths = @sba_application.section_rules.where(from_section_id: section_id)
      if paths.any?
        paths.each do |path|
          Rails.logger.debug "AMX:     Processing path : from: #{path.from_section.try(:name)} (#{path.from_section_id}) to : #{path.to_section.try(:name)} (#{path.to_section_id})"
          collection += find_possible_path(path.to_section_id)
        end
      end
      @tmp_cache[section_id] = collection.uniq
    end
  end

  def get_possible_path(section_id)
    if @tmp_cache[section_id]
      Rails.logger.debug "AMX:   Get path for section id from cache : #{section_id}"
      @tmp_cache[section_id]
    else
      Rails.logger.debug "AMX:   No data found for section id : #{section_id}"
      []
    end
  end
end
