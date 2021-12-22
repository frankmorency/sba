require 'sba_application/master_application'

class SbaApplication::EightAInfoRequest < SbaApplication::EightAMaster
  before_validation :set_kind, on: :create

  after_create  :copy_sections_and_rules, unless: :skip_copy_sections_and_rules

  def app_overview_title
    "8(a) Info Request"
  end

  def submit
    if program.try(:name) == "eight_a" && Feature.active?(:notifications)
      send_application_submited_notification(self)
    end

    submit_without_certificate

    current_review.resubmit! if returned_with_letter?

    certificate
  end

  def valid_application?
    ! certificate.pending?
  end

  private

  def set_kind
    self.kind = INFO_REQUEST
  end
end
