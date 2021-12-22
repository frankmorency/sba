module SbaWorkload
  extend ActiveSupport::Concern
  include SbaWorkloadHelper

  def hide_info_request
    sba_application = SbaApplication.find_by_id(param_to_int(:application_id))
    if current_user == sba_application.info_request_assigned_to
      sba_application.info_request_assigned_to_id = nil
      sba_application.save
    else
      flash[:error] = 'You are not assinged to this information request '
    end
    redirect_to root_path
  end

  private

  def param_to_int(param)
    param = Integer(params[param]) rescue 0
    param.to_i
  end
end