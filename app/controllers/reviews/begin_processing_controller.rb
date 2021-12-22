module Reviews
  class BeginProcessingController < BaseController
    include Wicked::Wizard

    steps :start, :finish, :add_a_note, :note_confirmation

    def show
      if @sba_application.kind == 'annual_review' && @sba_application.program.name == 'eight_a'
        @due_date = 30.days.from_now.to_date
      else
        @due_date = 90.days.from_now.to_date
      end
      render_wizard
    end

    def update
      case step
        when :start
          @review.process! if @review.can_process?
          ApplicationController.helpers.log_activity_application_state_change('accepted_processing', @sba_application.id, current_user.id)
          render_wizard @review
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
          render_wizard
      end
    end

    def invalid_note_params?
      params[:note_subject].nil? || params[:note_subject].blank? || params[:note_message].nil? || params[:note_message].blank? || params[:note_tags].nil? || params[:note_tags].blank?
    end
  end
end