module SbaAnalyst
  class RevisionsController < SbaAnalystController
    def index
      if params[:sba_application_id] && (params[:review_id] || params[:id])
        set_review
      else
        if current_user.can?(:ensure_vendor)
          set_application
        else
          set_application_open
        end

        @review = @sba_application.reviews.build
      end

      @revisions = @sba_application.revisions
    end
  end
end