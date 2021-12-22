module ContractingOfficer
  class AccessRequestsController < ContractingOfficerController
    before_action :authenticate_user!
    before_action :require_co_access, only: [:index, :new]

    include RequestAccessRequestsHelper

    def index
      list = VendorProfileAccessRequest.where(user_id: current_user.id)

      if list.blank?
        @access_requests = [VendorProfileAccessRequest.new]
      else
        @access_requests = list.joins(:user, :organization).
                           sba_search(
                             params[:search_input],
                             page: params[:page],
                             sort: {
                               column: params[:sort],
                               direction: sort_direction
                             })
      end
    end

    def create
      ac_params = access_request_params
      ac_params[:user_id] = current_user.id

      @access_request = VendorProfileAccessRequest.new(ac_params)

      respond_to do |format|
        if @access_request.save!
          @email_addresses = Organization.find(params[:access_request][:organization_id]).users.map(&:email)
          @solicitation_number = params[:access_request][:solicitation_number]
          ContractOfficerAccessRequestMailer.access_request_email(@email_addresses, @solicitation_number, current_user).deliver
          format.html { redirect_to contracting_officer_access_requests_path, notice: 'Access Request was successfully created.' }
        else
          format.html { render :new , notice: 'Your access request was not sent.'}
        end
      end
    end

    def search
      super
      
      if @organization.nil?
        render json: {id: nil}, :status => 200
      
      # is there an active WOBE program certificate?
      elsif @organization.certificates && @organization.certificates.joins(:certificate_type).where(certificate_types: {name: ['wosb', 'edwosb']}).map(&:workflow_state).include?('active')

        render json: {id: @organization.id, name: @organization.name, duns_number: @organization.duns_number, role_id: @role_id}, :status => 200

      else
        render json: {id: 'not_certified'}, :status => 200
      end
    end


    def access_request_params
      params.require(:access_request).permit(:organization_id,
                                             :solicitation_number,
                                             :solicitation_naics,
                                             :procurement_type,
                                             :role_id)
    end

  end
end
