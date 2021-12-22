class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_organization, except: [:pdf_viewer, :upload, :review_upload, :download_file]
  before_action :set_document, only: [:update_comment, :update_status]
  before_action :check_pdf_viewer_permissions, only: [:pdf_viewer, :download_file]

  def set_document
    @document = current_organization.documents.find(params[:id])
  end

  def pdf_viewer
    directory = @document.organization.folder_name
    file_name = @document.stored_file_name
    if @document.compressed?
      file_name = @document.compressed_stored_file_name
    end
    pdf_view(directory, file_name, @document.id, @document.organization.id)
  end

  def download_file
    send_data(Document.get_file_stream(@document.organization.folder_name, @document.stored_file_name, @document.original_file_name),
              :file_name => @document.original_file_name,
              :type => @document.mime_type,
              :disposition => "attachment; filename=#{@document.original_file_name}")
  end

  def update_comment
    previous_comment = @document.comment

    if @document.update({comment: params[:value]})
      render json: params[:value], :status => 200
    else
      render json: previous_comment, :status => 400
    end
  end

  def attach
    if params[:documents].nil?
      render json: {message: Document::STANDARD_UPLOAD_ERROR_MSG}, :status => 400
    else
      num_errors = 0
      successful_attachments = []

      params[:documents].each do |document_id, data|
        document = current_organization.documents.find(document_id)
        if document && document.update({comment: data[:comment],
                                        document_type_id: data[:document_type_id],
                                        original_file_name: data[:name]})
          doc_hash = {}
          document_type = DocumentType.find(document.document_type_id)
          doc_hash[document_type.name] = document if document_type
          successful_attachments << doc_hash
        else
          num_errors+=1
        end
      end

      if num_errors == params[:documents].length
        render json: {message: Document::STANDARD_UPLOAD_ERROR_MSG}, :status => 400
      else
        render json: {documents: successful_attachments}, :status => 200
      end
    end
  end

  def review_upload

    org = Organization.find(params[:organization_id])

    if params[:sba_application_object_type] == "Review::AdverseAction"
      app = Review::AdverseAction.find(params[:sba_application_id])
    else
      app = SbaApplication.find(params[:sba_application_id])
    end

    if params[:file].nil? || app.organization.id != org.id
      render json: {message: Document::STANDARD_UPLOAD_ERROR_MSG}, :status => 400
    else
      setup_analyst_document

      if params[:document_type] && params[:document_type] == 'analysis_letter'
        configure_document_parameters(DocumentType.find_by(name: 'Analysis Letter (Form 1392)').id)
      end

      if params[:document_type] && params[:document_type] == 'determination_letter'
        configure_document_parameters(DocumentType.find_by(name: 'Determination Letter').id)
      end

      if Document.upload_document(@document.organization.folder_name, params[:file].read, @document.stored_file_name, @document.original_file_name)
        store_analysis_letter_in_session if params[:document_type] == 'analysis_letter'
        store_determination_letter_in_session if params[:document_type] == 'determination_letter'
        render json: {document_id: @document.id, document_name: @document.original_file_name}, :status => 200
      else
        render json: {message: Document::STANDARD_UPLOAD_ERROR_MSG}, :status => 400
      end
    end
  end

  def upload
    if params[:file].nil?
      render json: {message: Document::STANDARD_UPLOAD_ERROR_MSG}, :status => 400
    else

      if params[:question_name] == 'analyst_document'
        setup_analyst_document
      else
        setup_firm_document
      end

      configure_document_parameters(DocumentType.find_by(name: 'Unknown').id)

      if Document.upload_document(@document.organization.folder_name, params[:file].read, @document.stored_file_name, @document.original_file_name) && @document.save!
        if params[:question_name] == 'analyst_document'
          # because of adverse action reviews
          if params[:really_review] && params[:really_review] == 'true'
            @sba_application = Review.find_by_id(params[:sba_application_id])
          else
            @sba_application = SbaApplication.find_by_id(params[:sba_application_id])
          end

          if current_user.is_sba? && @sba_application
            Document.make_association(@sba_application, Array.wrap(@document.id))
            render json: {message: "success",
                          document_id: @document.id,
                          file_name: @document.original_file_name,
                          file_size: params[:file].size}, :status => 200

            flash[:fileadded] = "In about 2 minutes, you can view the file. When it’s ready, the file name will be underlined."
          else
            render json: {message: Document::STANDARD_UPLOAD_ERROR_MSG}, :status => 400
          end
        else
          @document_types = Question.find_by(name: params[:question_name]).document_types
          render json: {message: "success",
                        document_id: @document.id,
                        file_name: @document.original_file_name,
                        file_size: params[:file].size,
                        document_types: @document_types}, :status => 200
        end

      else
        render json: {message: Document::STANDARD_UPLOAD_ERROR_MSG}, :status => 400
      end
    end
  end

  private

  def setup_analyst_document
    @document = Organization.find(params[:organization_id]).documents.new
    @document.is_analyst = true
  end

  def setup_firm_document
    set_current_organization
    @document = current_organization.documents.new
    @document.is_analyst = false
  end

  def configure_document_parameters document_type_id
    float_time = "%10.5f" % Time.now.to_f
    @document.stored_file_name = float_time.to_s
    @document.original_file_name = params[:file].original_filename
    @document.is_active = true
    @document.document_type_id = document_type_id
    @document.av_status = "Not Scanned"
    @document.user_id = current_user.id
  end

  def store_determination_letter_in_session
    session[:determination_document] = {}
    session[:determination_document][:stored_file_name] = @document.stored_file_name
    session[:determination_document][:original_file_name] = @document.original_file_name
    session[:determination_document][:document_type_id] = @document.document_type_id
    session[:determination_document][:is_active] = @document.is_active
    session[:determination_document][:av_status] = @document.av_status
    session[:determination_document][:user_id] = @document.user_id
    session[:determination_document][:is_analyst] = @document.is_analyst
  end

  def store_analysis_letter_in_session
    session[:analysis_document] = {}
    session[:analysis_document][:stored_file_name] = @document.stored_file_name
    session[:analysis_document][:original_file_name] = @document.original_file_name
    session[:analysis_document][:document_type_id] = @document.document_type_id
    session[:analysis_document][:is_active] = @document.is_active
    session[:analysis_document][:av_status] = @document.av_status
    session[:analysis_document][:user_id] = @document.user_id
    session[:analysis_document][:is_analyst] = @document.is_analyst
  end

  def check_pdf_viewer_permissions
    if can? :view_vendor_documents, current_user
      @organization = Organization.find(params[:organization_id])
    else
      set_current_organization
    end

    set_document

    if current_user.is_vendor_or_contributor? && current_user.id != @document.user.id
      return user_not_authorized
    end
  end
end
