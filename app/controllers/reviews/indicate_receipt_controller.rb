module Reviews
  class IndicateReceiptController < BaseController
    include Wicked::Wizard

    steps :select_request_type, :enter_receipt_date, :add_sba_note, :review, :acknowledgement

    def show
      case step
        when :select_request_type
          session.delete(:request_type)
        when :enter_receipt_date
        when :add_sba_note
        when :review
        when :acknowledgement
      end
      render_wizard
    end

    def update
      case step
        when :select_request_type
          session[:request_type] = params[:mailed_in]
          redirect_to wizard_path(@next_step)
        when :enter_receipt_date
          session[:receipt_date] = params[:receipt_date]
          redirect_to wizard_path(@next_step)
        when :add_sba_note
          unless note_skipped?
            if invalid_note_params?
              flash.now[:error] = 'Please make sure you have filled in all required fields.'
              render_wizard
            else
              session[:note_subject] = params[:note_subject]
              session[:note_message] = params[:note_message]
              session[:note_tags] = params[:note_tags]
              redirect_to wizard_path(@next_step)
            end
          end
        when :review
          # update Next Action Due field
          if session[:request_type] == 'appeal'
            @review.user_submit_appeal!
            ApplicationController.helpers.log_activity_application_state_change('appeal_submitted_by_mail', @sba_application.id, current_user.id)
          else
            @sba_application.last_reconsideration_application.submit!
            @sba_application.submit!
            converted_date = Date.parse(Time.parse(session[:receipt_date]).utc.to_s)
            @review.update_attribute :processing_due_date, converted_date + 45.days
            ApplicationController.helpers.log_activity_application_state_change('reconsideration_submitted_by_mail', @sba_application.id, current_user.id)
          end

          # create and save note
          if note_session_available?
            create_note session[:note_subject], session[:note_message], session[:note_tags]
            if @note.save!
              render_wizard @note
            else
              flash.now[:error] = 'There was an error saving your note. Please try again.'
              render_wizard
            end
          else
            redirect_to wizard_path(@next_step)
          end
        when :acknowledgement
          redirect_to wizard_path(@next_step)
      end
    end

    private

    def note_skipped?
      params[:note_subject].nil? && params[:note_message].nil? && params[:note_tags].nil?
    end

    def note_session_available?
      session[:note_subject] && !session[:note_subject].blank? && session[:note_message] && !session[:note_message].blank? && session[:note_tags] && !session[:note_tags].blank?
    end

  end
end
