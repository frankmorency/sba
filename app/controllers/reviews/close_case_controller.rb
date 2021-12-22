module Reviews
  class CloseCaseController < BaseController
    include Wicked::Wizard
    include NotificationsHelper

    steps :add_sba_note, :compose_message, :close_case, :confirmation

    def show
      case step
        when :add_sba_note
          delete_session_vars
        when :compose_message
          @deliver_to = @sba_application.organization.owner_name
      end
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
        when :compose_message
          set_message_session
          redirect_to wizard_path(@next_step)
        when :close_case
          @sba_application.current_review.close!
          create_note session[:note_subject], session[:note_message], session[:note_tags]
          delete_note_session

          if Feature.active?(:notifications) && @sba_application.organization.default_user
            create_message_object
            send_official_message(@close_case_message, current_user, @sba_application.organization.default_user, @sba_application) if Feature.active?(:notifications)
            delete_message_session
            vendor = @sba_application.organization.default_user
            send_application_closed_notification("8(a)", master_application_type(@sba_application), vendor.id, @sba_application.id, vendor.email) if Feature.active?(:notifications)
          end

          ApplicationController.helpers.log_activity_application_state_change('closed_unresponsive', @sba_application.id, current_user.id)
          flash[:success] = 'This application has been successfully closed.'
          redirect_to sba_application_application_dashboard_overview_index_path(@sba_application)
      end
    end

    private

    def create_message_object
      @close_case_message = CloseCaseLetter.new
      @close_case_message.subject = session[:subject]
      @close_case_message.message = session[:message]
    end

    def delete_session_vars
      session.delete(:note_subject)
      session.delete(:note_message)
      session.delete(:note_tags)
      session.delete(:subject)
      session.delete(:message)
    end

    def set_message_session
      session[:deliver_to] = params[:deliver_to]
      session[:subject] = params[:subject]
      session[:message] = params[:message]
    end

    def delete_message_session
      session.delete(:deliver_to)
      session.delete(:subject)
      session.delete(:message)
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
