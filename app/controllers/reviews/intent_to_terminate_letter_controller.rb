module Reviews
  class IntentToTerminateLetterController < BaseController
    include Wicked::Wizard
    include NotificationsHelper

    steps :compose_message, :review, :finish, :add_a_note, :note_confirmation

    def show
      case step
        when :compose_message
          @recipient = @sba_application.organization.owner_name
        when :review
        when :finish
      end
      render_wizard
    end

    def update
      case step
        when :compose_message
          session[:recipient] = params[:recipient]
          session[:subject] = params[:subject]
          session[:message] = params[:message]
          redirect_to wizard_path(@next_step)
        when :review
          if Feature.active?(:notifications)
            @intent_to_terminate_letter = IntentToTerminateLetter.new
            @intent_to_terminate_letter.subject = session[:subject]
            @intent_to_terminate_letter.message = session[:message]
            send_official_message(@intent_to_terminate_letter, current_user, @sba_application.organization.default_user, @sba_application)
            session.delete(:subject)
            session.delete(:message)
          end
          redirect_to wizard_path(@next_step)
        when :add_a_note
          if invalid_note_params?
            flash.now[:error] = 'Please make sure you have filled in all required fields.'
            render_wizard
          else
            @note = Note.new(notated_id: @sba_application.id, notated_type: @sba_application.class.to_s, title: params[:note_subject], body: params[:note_message], author_id: current_user.id, published: true, tags: params[:note_tags])
            if @note.save!
              render_wizard @note
            else
              flash.now[:error] = 'There was an error saving your note. Please try again.'
              render_wizard
            end
          end
        else
          redirect_to wizard_path(@next_step)
      end
    end

  end
end