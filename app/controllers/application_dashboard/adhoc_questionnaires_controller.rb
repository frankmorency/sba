module ApplicationDashboard
  class AdhocQuestionnairesController < BaseController
    before_action :set_sub_application

    def index
      @adhoc_sections = @sba_application.sections.find_by(sub_application_id: @sub_application.id).adhoc_sections
      @master_application = @sba_application
      @sba_application = @sub_application
    end
  end
end
