module ProgramParticipation
  class AMPPResultSet < ResultSetBase
    def program
      Program.find_by(name: 'asmpp')
    end

    def name
      program.name
    end
  end
end
