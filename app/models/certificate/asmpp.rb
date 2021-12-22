class Certificate::ASMPP < Certificate
  include CertificateWorkflow

  def self.create_annual_reviews!(days_ahead = 30.days, exclude_duns = [])
    # look at implementation in Certificate::EightA for an example
  end

  def decision
    self.ineligible? ? 'Declined' : ''
  end

  def renewable?(user)
    false
  end
end
