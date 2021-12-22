require 'sba_application/master_application'

class SbaApplication::AdverseActionBlank < SbaApplication::EightAMaster
  before_validation :set_kind, on: :create

  after_create  :copy_sections_and_rules, unless: :skip_copy_sections_and_rules

  def app_overview_title
    "Adverse Action"
  end

  def submit
    submit_without_certificate

    certificate
  end

  def valid_application?
    true
  end

  private

  def set_kind
    self.kind = INFO_REQUEST
  end
end
