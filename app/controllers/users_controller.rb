class UsersController < VendorAdminController

  before_action :require_vendor_admin_access, only: []

  def find_business
    sam_org = MvwSamOrganization.find_business(params[:search])
    @sam_organizations = Array.new
    unless sam_org.nil?
      @sam_organizations << sam_org
    end
    @sam_organizations
  end

  def associate_business
    duns_number = $encryptor.decrypt(params[:duns_number])
    tax_identifier = $encryptor.decrypt(params[:tax_identifier])

    org = Organization.find_by(duns_number: duns_number)

    if org
      org.business_type = params[:business_type] if params[:business_type]
      org.tax_identifier = tax_identifier if tax_identifier
      org.tax_identifier_type if params[:tax_identifier_type]
      org.save!
    else
      org = Organization.create(duns_number: duns_number,
                                tax_identifier: tax_identifier,
                                tax_identifier_type: params[:tax_identifier_type],
                                business_type: params[:business_type])
    end

    if org.vendor_admin_user.nil?
      # create an approved request access request so that this user can later be revoked if needed
      VendorRoleAccessRequest.add_first_user(current_user, org, :vendor_admin)
      if current_user.save
        if org.has_migrated_bdmis_application?

          sba_app = org.sba_applications.where.not(bdmis_case_number: nil).first
          unless sba_app.nil?
            sba_app.creator_id = current_user.id
          end

          # associate docs
          org.documents.each do |document|
            document.user_id = current_user.id
            document.save
          end
        end

        flash[:info] = 'You have been successfully associated with the organization.'
      else
        flash[:error] = 'We could not associate you to this organization. Please contact the Certify Support Desk at https://certify.sba.gov/help'
      end
    else
      flash[:error] = 'The organization is already associated with a different user. Please contact the Certify Support Desk at https://certify.sba.gov/help'
    end

    redirect_to vendor_admin_dashboard_index_path
  end

  def welcome_to_sba
  end

  def request_vendor_role
    if params["request"] == "request_vendor_admin"
      redirect_to new_vendor_admin_role_access_request_path(role: :vendor_admin)
    elsif params["request"] == "request_vendor_editor"
      redirect_to new_vendor_admin_role_access_request_path(role: :vendor_editor)
    else
      redirect_to :find_business
    end
  end
end
