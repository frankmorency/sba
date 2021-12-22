module ProgramParticipation
  class EightAResultSet < ResultSetBase
    def program
      Program.find_by(name: 'eight_a')
    end

    def name
      program.name
    end
  end
end
