module RequestAccessRequestsHelper

  def new
  end

  def search
    @organization = nil
    @role_id = nil
    if params[:duns_number].nil?
      render json: {message: 'Please enter a DUNS number'}, :status => 400
    else
      @organization = Organization.find_by(duns_number: params[:duns_number])
      @role_id = Role.find_by_name(params[:role_name]).id unless params[:role_name].blank?
    end
  end

  def sort_column
    AccessRequest.sort_column(params[:sort])
  end

  protected

    def set_access_request
      @access_request = AccessRequest.find(params[:id])
    end
end
