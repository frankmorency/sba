module Reviews
  class RequestAdhocReviewController < BaseController
    include Wicked::Wizard

    steps :start, :finish

    def show
      @adhoc_request = AdhocRequest.new(sub_section_name: params[:sub_section_name])
      render_wizard
    end

    def update
      case step
        when :start
          @adhoc_request = AdhocRequest.new(params[:adhoc_request])
          @sba_application.adhoc_section_root.create_adhoc_app(@adhoc_request)
          redirect_to next_wizard_path
        when :finish
          render_wizard
      end
    end
  end
end