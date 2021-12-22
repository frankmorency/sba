class CertificateController < ApplicationController
  before_action :authenticate_user!

  def show
    if can? :view_vendor_profile, current_user
      @organization = Organization.find(params[:organization_id])
    else
      set_current_organization
    end

    set_certificate

    file_name = "#{@certificate.certificate_type.name}_certificate_#{@certificate.id}.pdf"
    pdf_view("#{@certificate.organization.folder_name}/generated_docs", file_name)
  end

  private

  def set_certificate
    @certificate = @organization.certificates.find(certificate_params)
  end

  def certificate_params
    params.require(:id)
  end
end
