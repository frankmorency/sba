module Admin
  class SectionsController < BaseController
    def index
      @sections = Section.includes(:section_rule_origins).where(sba_application_id: nil)
    end
  end
end
