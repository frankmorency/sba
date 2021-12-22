class Section
  class SignatureSectionsController < BaseController
    def edit

      # redirect to application_dashabord/overview if we get to the signature page and the application is not ready to be submitted. 
      if @sba_application.is_a?(SbaApplication::MasterApplication)
        redirect_to sba_application_application_dashboard_overview_index_path(@sba_application) unless @sba_application.can_be_submitted?
      end

      unless @signature_terms
        @signature_terms = Signature.new(@questionnaire).terms
      end

      @signatory = current_user

      @questions = []

      super
    end

    protected

    def get_progress
      SbaApplication::Progress.new(@sba_application, @user, @section)
    end
  end
end
