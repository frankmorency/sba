require "csv"

module CasesCSV
  extend ActiveSupport::Concern

  def firm_name(program = {})
    legal_business_name
  end

  def firm_owner(program = {})
    self.vendor_admin_user&.name
  end

  def firm_type(program = {})
    business_type
  end

  def naics(program = {})
    self.to_sam&.primary_naics
  end

  def cage(program = {})
    self.to_sam&.cage_code
  end

  def dba(program = {})
    self.to_sam&.dba_name
  end

  def tax_identifier_csv(program = {})
    tax_identifier
  end

  def firm_contact(program = {})
    self.to_sam&.govt_bus_poc_last_name
  end

  def email(program = {})
    self.to_sam&.govt_bus_poc_email
  end

  def phone_number(program = {})
    self.to_sam&.govt_bus_poc_us_phone
  end

  def mailing_address(program = {})
    self.to_sam&.mailing_address_line_1
  end

  def most_recent_8a_cert(program = {})
    self.certificates.joins(:certificate_type).where("certificate_types.name = ?", "eight_a").first
  end

  def most_recent_mpp_cert(program = {})
    self.certificates.joins(:certificate_type).where("certificate_types.name = ?", "mpp").first
  end

  def most_recent_wosb_cert(program = {})
    self.certificates.joins(:certificate_type).where("certificate_types.name IN ('wosb','edwosb')").first
  end

  def certificate_program_title(program = {})
    case program
    when "EIGHT_A"
      self.most_recent_8a_cert&.certificate_type&.title
    when "MPP"
      self.most_recent_mpp_cert&.certificate_type&.title
    when "WOSB"
      self.most_recent_wosb_cert&.certificate_type&.title
    end
  end

  def certificate_review_type(program = {})
    case program
    when "EIGHT_A"
      self.most_recent_8a_cert&.current_review&.type
    when "MPP"
      self.most_recent_mpp_cert&.current_review&.type
    when "WOSB"
      self.most_recent_wosb_cert&.current_review&.type
    end
  end

  def certificate_status_humanized(program = {})
    case program
    when "EIGHT_A"
      self.most_recent_8a_cert&.display_status
    when "MPP"
      self.most_recent_mpp_cert&.display_status
    when "WOSB"
      self.most_recent_wosb_cert&.display_status
    end
  end

  def certificate_date_submitted(program = {})
    case program
    when "EIGHT_A"
      self.most_recent_8a_cert&.current_application.application_submitted_at&.to_date
    when "MPP"
      self.most_recent_mpp_cert&.current_application.application_submitted_at&.to_date
    when "WOSB"
      self.most_recent_wosb_cert&.current_application.application_submitted_at&.to_date
    end
  end

  def certificate_anniversary_date(program = {})
    case program
    when "EIGHT_A"
      self.most_recent_8a_cert&.issue_date&.strftime("%m/%d")
    when "MPP"
      self.most_recent_mpp_cert&.issue_date&.strftime("%m/%d")
    when "WOSB"
      self.most_recent_wosb_cert&.issue_date&.strftime("%m/%d")
    end
  end

  def certificate_due_date(program = {})
    case program
    when "EIGHT_A"
      self.most_recent_8a_cert&.current_application.screening_due_date
    when "MPP"
      self.most_recent_mpp_cert&.current_application.screening_due_date
    when "WOSB"
      self.most_recent_wosb_cert&.current_application.screening_due_date
    end
  end

  def certificate_expiration_date(program = {})
    case program
    when "EIGHT_A"
      self.most_recent_8a_cert&.expiry_date&.to_date
    when "MPP"
      self.most_recent_mpp_cert&.expiry_date&.to_date
    when "WOSB"
      self.most_recent_wosb_cert&.expiry_date&.to_date
    end
  end

  def certificate_approval_date(program = {})
    case program
    when "EIGHT_A"
      self.most_recent_8a_cert&.issue_date&.to_date
    when "MPP"
      self.most_recent_mpp_cert&.issue_date&.to_date
    when "WOSB"
      self.most_recent_wosb_cert&.issue_date&.to_date
    end
  end

  def certificate_case_owner(program = {})
    case program
    when "EIGHT_A"
      self.most_recent_8a_cert&.current_review&.current_assignment&.owner&.name
    when "MPP"
      self.most_recent_mpp_cert&.current_review&.current_assignment&.owner&.name
    when "WOSB"
      self.most_recent_wosb_cert&.current_review&.current_assignment&.owner&.name
    end
  end

  # def certificate_case_assignee(program = {})
  #   case program
  #     when 'EIGHT_A'
  #       self.most_recent_8a_cert&.current_review&.current_assignment&.current_reviewer&.name
  #     when 'MPP'
  #       self.most_recent_mpp_cert&.current_review&.current_assignment&.current_reviewer&.name
  #     when 'WOSB'
  #       self.most_recent_wosb_cert&.current_review&.current_assignment&.current_reviewer&.name
  #   end
  # end

  def certificate_current_reviewer(program = {})
    case program
    when "EIGHT_A"
      self.most_recent_8a_cert&.current_review&.current_assignment&.reviewer&.name
    when "MPP"
      self.most_recent_mpp_cert&.current_review&.current_assignment&.reviewer&.name
    when "WOSB"
      self.most_recent_wosb_cert&.current_review&.current_assignment&.reviewer&.name
    end
  end

  def certificate_district_office(program = {})
    case program
    when "EIGHT_A"
      self.most_recent_8a_cert&.duty_station&.name
    when "MPP"
      self.most_recent_mpp_cert&.duty_station&.name
    when "WOSB"
      self.most_recent_wosb_cert&.duty_station&.name
    end
  end

  def certificate_servicing_bos(program = {})
    case program
    when "EIGHT_A"
      self.most_recent_8a_cert&.servicing_bos&.name
    when "MPP"
      self.most_recent_mpp_cert&.servicing_bos&.name
    when "WOSB"
      self.most_recent_wosb_cert&.servicing_bos&.name
    end
  end

  def most_recent_review(program = {})
    case program
    when "EIGHT_A"
      self.most_recent_8a_cert&.reviews.order(created_at: :desc).first
    when "MPP"
      self.most_recent_mpp_cert&.reviews.order(created_at: :desc).first
    when "WOSB"
      self.most_recent_wosb_cert&.reviews.order(created_at: :desc).first
    end
  end

  def review_type(program = {})
    self.most_recent_review(program)&.type
  end

  def review_status(program = {})
    self.most_recent_review(program)&.workflow_state
  end

  def review_status_humanized(program = {})
    self.most_recent_review(program)&.display_status
  end

  def review_determination(program = {})
    self.most_recent_review(program)&.determination&.decision
  end

  def review_determination_humanized(program = {})
    self.most_recent_review(program)&.determination&.display_decision
  end

  def review_case_owner(program = {})
    self.most_recent_review(program)&.current_assignment&.owner&.name
  end

  def review_current_reviewer(program = {})
    self.most_recent_review(program)&.current_assignment&.reviewer&.name
  end

  def review_date_created(program = {})
    self.most_recent_review(program)&.created_at&.to_date
  end

  def review_screening_due_date(program = {})
    self.most_recent_review(program)&.screening_due_date&.to_date
  end

  def review_processing_due_date(program = {})
    self.most_recent_review(program)&.processing_due_date&.to_date
  end

  def review_letter_due_date(program = {})
    self.most_recent_review(program)&.letter_due_date&.to_date
  end

  def self.search_csv(orgs, program)
    header = ["firm_name",
              "firm_owner",
              "firm_type",
              "naics",
              "cage",
              "dba",
              "tax_identifier",
              "firm_contact",
              "email",
              "phone_number",
              "mailing_address",
              "program name",
              "certificate_review_type",
              "certificate_status",
              # "certificate_date_submitted",
              "certificate_anniversary_date",
              "certificate_due_date",
              "certificate_expiration_date",
              "certificate_approval_date",
              "certificate_case_owner",
              "certificate_current_reviewer",
              "certificate_district_office",
              "certificate_servicing_bos",
              "review_type",
              "review_status",
              "review_status_humanized",
              "review_determination",
              "review_determination_humanized",
              "review_case_owner",
              "review_current_reviewer",
              "review_date_created",
              "review_screening_due_date",
              "review_processing_due_date",
              "review_letter_due_date"]

    row = ["firm_name",
           "firm_owner",
           "firm_type",
           "naics",
           "cage",
           "dba",
           "tax_identifier_csv",
           "firm_contact",
           "email",
           "phone_number",
           "mailing_address",
           "certificate_program_title",
           "certificate_review_type",
           "certificate_status_humanized",
          #  "certificate_date_submitted",
           "certificate_anniversary_date",
           "certificate_due_date",
           "certificate_expiration_date",
           "certificate_approval_date",
           "certificate_case_owner",
           "certificate_current_reviewer",
           "certificate_district_office",
           "certificate_servicing_bos",
           "review_type",
           "review_status",
           "review_status_humanized",
           "review_determination",
           "review_determination_humanized",
           "review_case_owner",
           "review_current_reviewer",
           "review_date_created",
           "review_screening_due_date",
           "review_processing_due_date",
           "review_letter_due_date"]

    CSV.generate(headers: true) do |csv|
      csv << header
      orgs.each do |organization_id|
        begin
          if Organization.find_by(id: organization_id)
            csv << row.map { |attr| Organization.find(organization_id).send(attr.to_sym, program) if !attr.nil? }
          end
        rescue StandardError => e
          csv << ["Error in org id/ duns : ", organization_id, Organization.find(organization_id).duns_number]
        end
      end
    end
  end
end
