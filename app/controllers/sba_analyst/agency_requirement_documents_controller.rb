module SbaAnalyst
  class AgencyRequirementDocumentsController < SbaAnalystController

    before_filter :set_agency_requirement, :only => [:new, :create, :destroy, :download]

    def new
      @agency_requirement_document = AgencyRequirementDocument.new
    end

    def create
      @agency_requirement_document = AgencyRequirement.find(params[:agency_requirement_id]).agency_requirement_documents.new

      if invalid_params?
        flash[:error] = "Field(s) missing. Please select the Document Type and a File."
        redirect_to :back
        return
      end

      configure_document_parameters

      if @agency_requirement_document.invalid?
        flash[:error] = @agency_requirement_document.errors.full_messages.join(", ")
        redirect_to :back
        return
      end

      if AgencyRequirementDocument.upload_document(@agency_requirement_document.folder_name, params[:agency_requirement_document][:file].read, @agency_requirement_document.stored_file_name, @agency_requirement_document.original_file_name) && @agency_requirement_document.save!
        flash[:fileadded] = "File added successfully."
        redirect_to :back
      else
        flash[:error] = AgencyRequirementDocument::STANDARD_UPLOAD_ERROR_MSG
        redirect_to :back
      end
    end

    def destroy
      @agency_requirement_document = @agency_requirement.agency_requirement_documents.find(params[:id])

      if @agency_requirement_document.destroy
        flash[:success] = "File #{@agency_requirement_document.original_file_name} was successfully deleted."
      else
        flash[:error] = "Failed to delete File #{@agency_requirement_document.original_file_name}."
      end
      redirect_to :back
    end

    def download
      @agency_requirement_document = @agency_requirement.agency_requirement_documents.find(params[:agency_requirement_document_id])
      send_data(AgencyRequirementDocument.get_file_stream(@agency_requirement_document.folder_name, @agency_requirement_document.stored_file_name, @agency_requirement_document.original_file_name),
                :file_name => @agency_requirement_document.original_file_name,
                :type => @agency_requirement_document.mime_type,
                :disposition => "attachment; filename=#{@agency_requirement_document.original_file_name}")
    end

    private
    def configure_document_parameters
      @agency_requirement_document.original_file_name = params[:agency_requirement_document][:file].original_filename
      @agency_requirement_document.is_active = true
      @agency_requirement_document.document_type = params[:agency_requirement_document][:document_type]
      @agency_requirement_document.av_status = "Not Scanned"
      @agency_requirement_document.user_id = current_user.id
      @agency_requirement_document.comment = params[:agency_requirement_document][:comment]
    end

    def set_agency_requirement
      @agency_requirement = AgencyRequirement.find(params[:agency_requirement_id])
    end

    def invalid_params?
      params[:agency_requirement_document].keys.sort != ["document_type", "file", "comment"].sort
    end
  end
end