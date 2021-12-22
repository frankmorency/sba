module ProgramParticipation
  class MppResultSet < ResultSetBase
    def program
      Program.find_by(name: 'mpp')
    end

    def name
      program.name
    end

    def annual_reports
      AnnualReport.where("sba_application_id IN (?)", organization.sba_applications.collect(&:id)).group_by(&:program)
    end
  end
end
