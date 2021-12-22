module DiscussionsHelper
  protected

  def current_application
    if current_user.is_vendor_or_contributor?
      # checking that the application belongs to the vendor
      if !current_user.organizations.first.nil?
        @current_application = current_user.organizations.first.sba_applications.select { |app| app.id == params[:sba_application_id].to_i }.first
      else
        raise "current_application needs to be scoped to the user organization."
      end
    else
      # this is for sba users.
      @current_application ||= SbaApplication.find_by(id: current_applications_params[:sba_application_id].to_i)
    end
    @review = @current_application.current_review if @current_application
    @current_application
  end

  def current_applications_params
    params.permit(:sba_application_id)
  end

  def current_recipient
    @current_recipient = nil
    if current_application
      @current_recipient = current_application.get_current_analyst_owner
    else
      # we don't know the recipient for sba users.
      @current_recipient = nil
    end
    @current_recipient
  end
end
