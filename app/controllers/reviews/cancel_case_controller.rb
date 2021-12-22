module Reviews
  class CancelCaseController < BaseController
    include Wicked::Wizard
    include NotificationsHelper

    steps :add_sba_note, :cancel_case

    def show
      delete_session_vars if step == :add_sba_note

      render_wizard
    end

    def update
      case step
      when :add_sba_note
        if invalid_note_params?
          flash.now[:error] = 'Please make sure you have filled in all required fields.'
          render_wizard
        else
          set_note_session
          redirect_to wizard_path(@next_step)
        end
      when :cancel_case
        @sba_application.current_review.cancel!
        create_note session[:note_subject], session[:note_message], session[:note_tags]
        delete_note_session

        # ApplicationController.helpers.log_activity_application_state_change('closed_unresponsive', @sba_application.id, current_user.id)
        flash[:success] = 'This application has been successfully cancelled.'
        redirect_to "/organizations/#{@sba_application.certificate.organization_id}/adverse_action_reviews/#{@sba_application.current_review.case_number}"
      end
    end

    private

    def delete_session_vars
      session.delete(:note_subject)
      session.delete(:note_message)
      session.delete(:note_tags)
    end


    def set_note_session
      session[:note_subject] = params[:note_subject]
      session[:note_message] = params[:note_message]
      session[:note_tags] = params[:note_tags]
    end

    def delete_note_session
      session.delete(:note_subject)
      session.delete(:note_message)
      session.delete(:note_tags)
    end
  end
end
