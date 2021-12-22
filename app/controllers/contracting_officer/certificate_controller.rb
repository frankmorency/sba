class ContractingOfficer::CertificateController < ContractingOfficerController
  before_action :authenticate_user!
  before_action :require_co_access

  def show
    @organization = Organization.find(params[:organization_id])
    @sba_application = @organization.sba_applications.find(params[:id])

    unless current_user.has_access?(@organization)
      render status: 403
      return
    end

    @organization = Organization.find(params[:organization_id])
    @certificate = @organization.certificates.find(certificate_params)

    file_name = "#{@certificate.certificate_type.name}_certificate_#{@certificate.id}"
    pdf_view("#{@certificate.organization.folder_name}/generated_docs", file_name)
  end

  private

  def certificate_params
    params.require(:id)
  end
end
