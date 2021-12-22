module DataUpdates
  class EightAExpiry < Base
    attr_accessor :certificate_type

    def initialize(commit = true)
      @certificate_type = CertificateType.get('eight_a')
      @commit = commit
    end

    def update!
      certificate_type.certificates.where('issue_date IS NOT NULL AND expiry_date IS NOT NULL').reject(&:from_bdmis?).each do |cert|
        cert.expiry_date = cert.issue_date + certificate_type.duration_in_days.days
        if commit
          cert.update_attribute :expiry_date, cert.expiry_date
        end
      end
    end
  end
end