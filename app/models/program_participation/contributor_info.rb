module ProgramParticipation
  class ContributorInfo
    include ApplicationHelper
    delegate :url_helpers, to: 'Rails.application.routes'

    attr_accessor :current_user, :contributor_application, :questionnaire_id, :section, :master_application, :contributor, :organization

    def initialize(user, contributor)
      @current_user = user
      @section, @contributor_application, @questionnaire_id, @master_application = contributor.details
      @contributor = contributor
      @organization = @master_application.organization
    end

    def new_application?
      contributor_application.nil?
    end

    def app_complete?
      section.app_complete?
    end

    def new_application_url
      url_helpers.new_master_application_section_questionnaire_sba_application_path(contributor.sba_application.id, section.id, questionnaire_id) + "?contributor_id=#{contributor.id}"
    end

    def existing_application_url
      next_section = contributor_application.sections.find_by(name: contributor_application.progress["current"])
      return unless next_section
      section_path_helper(contributor_application, next_section, true)
    end
  end
end
