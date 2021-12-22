module SbaAnalyst
  class CertificatesController < SbaAnalystController
    def edit
      @certificate = Certificate.find(params[:id])
    end
  end
end
