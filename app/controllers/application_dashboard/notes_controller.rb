module ApplicationDashboard
  class NotesController < BaseController
    before_action :ensure_sba_user

    def index
      @notes = Note.where(notated_id: @sba_application.id, notated_type: @sba_application.class.to_s)
    end

    def create
      if invalid_note_params?
        error_message = 'Please make sure you have filled in all required fields.'
        render json: {message: error_message}, :status => 400
      else
        note = Note.new(notated_id: @sba_application.id, notated_type: @sba_application.class.to_s, title: params[:subject], body: params[:message], author_id: current_user.id, published: true, tags: params[:tags])

        if note.save!
          ApplicationController.helpers.log_activity_application_event('note_created', @sba_application.id, current_user.id, note.id)
          render json: {message: 'Note added!'}, :status => 200
        else
          error_message = 'There was an error saving your note. Please try again.'
          render json: {message: error_message}, :status => 400
        end
      end
    end

    def invalid_note_params?
      params[:subject].nil? || params[:subject].blank? || params[:message].nil? || params[:message].blank? || params[:tags].nil? || params[:tags].blank?
    end
  end
end