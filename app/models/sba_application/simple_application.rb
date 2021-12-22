require 'sba_application'

class SbaApplication::SimpleApplication < SbaApplication
  include SbaApplicationWorkflow
  include GeneralApplicationWorkflow

  def drafty?
    draft?
  end

  def submit
    if is_mpp_annual_report?
      transaction do
        submit_without_certificate(false)
        if ar = AnnualReport.find_by_sba_application_id(id)
          ar.update_attribute :status, nil
        else
          AnnualReport.create!(certificate: original_certificate, sba_application: self)
        end
      end
    else
      super
    end
  end
end
