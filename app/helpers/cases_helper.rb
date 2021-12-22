module CasesHelper

  def case_date_submitted(current_case, program)
    case program
      when 'EIGHT_A'
        return Date.parse(current_case.submit_date_eight_a).strftime("%m/%d/%Y") if current_case.submit_date_eight_a.present?
      when 'MPP'
        return Date.parse(current_case.submit_date_mpp).strftime("%m/%d/%Y") if current_case.submit_date_mpp.present?
      when 'WOSB'
        return Date.parse(current_case.submit_date_wosb).strftime("%m/%d/%Y") if current_case.submit_date_wosb.present?
    end
    nil
  end
end
