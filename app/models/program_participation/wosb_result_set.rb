module ProgramParticipation
  class WosbResultSet < ResultSetBase
    def program
      Program.find_by(name: 'wosb')
    end

    def name
      program.name
    end

    def certificates
      organization.displayable_certificates.joins(:certificate_type).where('certificate_types.name =? OR certificate_types.name = ?', 'wosb', 'edwosb').map {|cert| ProgramParticipation::CertificateResult.new(cert) }
    end
  end
end
