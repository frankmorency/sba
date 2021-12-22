class Section
  class ContributorSectionsController < BaseController
    before_action   :set_permissions
    before_action   :ensure_vendor_admin
    
    def edit
      @questions = []
      @questionnaire_layout = false
      @signature_terms = []
    end
  end
end
