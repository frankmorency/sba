class Program::BaseController < ApplicationController
  before_action   :authenticate_user!
  before_action   :ensure_sba_user

  protected

  def invalid_note_params?
    params[:note_subject].nil? || params[:note_subject].blank? || params[:note_message].nil? || params[:note_message].blank? || params[:note_tags].nil? || params[:note_tags].blank?
  end

  def create_note subject, message, tags
    @note = Note.create!(notated_id: @sba_application.id, notated_type: @sba_application.class.to_s, title: subject, body: message, author_id: current_user.id, published: true, tags: tags)
    ApplicationController.helpers.log_activity_application_event('note_created', @sba_application.id, current_user.id, @note.id)
  end

  def create_analysis_letter
    document = Document.create!(
        organization_id: @organization.id,
        stored_file_name: session[:analysis_document][:stored_file_name],
        original_file_name: session[:analysis_document][:original_file_name],
        document_type_id: session[:analysis_document][:document_type_id],
        is_active: session[:analysis_document][:is_active],
        av_status: session[:analysis_document][:av_status],
        user_id: session[:analysis_document][:user_id],
        is_analyst: session[:analysis_document][:is_analyst]
    )

    Document.make_association(@sba_application, Array.wrap(document.id))
  end

  def create_determination_letter
    document = Document.create!(
        organization_id: @organization.id,
        stored_file_name: session[:determination_document][:stored_file_name],
        original_file_name: session[:determination_document][:original_file_name],
        document_type_id: session[:determination_document][:document_type_id],
        is_active: session[:determination_document][:is_active],
        av_status: session[:determination_document][:av_status],
        user_id: session[:determination_document][:user_id],
        is_analyst: session[:determination_document][:is_analyst]
    )

    Document.make_association(@sba_application, Array.wrap(document.id))
  end
end
