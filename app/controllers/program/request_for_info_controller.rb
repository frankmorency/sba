class Program::RequestForInfoController < Program::BaseController
  include Wicked::Wizard

  steps :start, :request_info

  def show
    @info_request = InformationRequest.new(params[:information_request])
    @info_request.deliver_to = @info_request.organization.users.map {|user|  [user.full_name, user.id] }
    render_wizard
  end

  def update
    if step == :request_info
      @info_request = InformationRequest.new(params[:information_request])
      @info_request.assigned_to = current_user
      @info_request.create_application!
      session[:flash_title] = "A new questionnaire has been created"
      flash[:success] = "The firm has been notified."
      redirect_to sba_analyst_dashboard_show_path(enc: $encryptor.encrypt("duns_number=#{@info_request.organization.duns_number}&tax_identifier=#{@info_request.organization.tax_identifier}"))
    end
  end
end
