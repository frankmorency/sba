module RespondAccessRequestsHelper

  def accept
    if @access_request.accept!(current_user)
      flash[:notice] = 'Access request has been accepted'
    else
      flash[:error] = 'There was a problem with Accepting your Access request.'
    end
  end

  def revoke
    if @access_request.revoke!(current_user)
      flash[:notice] = 'Access request has been revoked'
    else
      flash[:error] = 'There was a problem with revoking your Access request.'
    end
  end

  def reject
    if @access_request.reject!(current_user)
      flash[:notice] = 'Access request has been rejected'
    else
      flash[:error] = 'There was a problem with rejecting your Access request.'
    end
  end

  def sort_column
    AccessRequest.sort_column(params[:sort])
  end

  private

  # TODO: should be move to subclass?
  def set_request
    @access_request = @organization.access_requests.find(params[:access_request_id] || params[:id] || params[:role_access_request_id])
  end
end
