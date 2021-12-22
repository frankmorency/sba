module ProgramParticipation
  class ResultSet < ResultSetBase
    attr_accessor :wosb, :mpp, :eight_a, :asmpp

    def initialize(org, user)
      super(org, user)

      @wosb = ProgramParticipation::WosbResultSet.new(org, user)
      @mpp = ProgramParticipation::MppResultSet.new(org, user)
      @eight_a = ProgramParticipation::EightAResultSet.new(org, user)
      @asmpp = ProgramParticipation::AMPPResultSet.new(org, user) if Feature.active?(:asmpp)
    end

    def programs
      if Feature.active?(:asmpp)
        [@eight_a, @mpp, @asmpp]
      else
        [@eight_a, @mpp]
      end
    end

    def empty?
      return false if Feature.active?(:asmpp) && !@asmpp.blank?
      wosb.empty? && mpp.empty? && eight_a.empty?
    end

    def documents
      organization.documents.where(user_id: current_user.id).order(:updated_at).reverse_order.limit(10).order(created_at: 'desc')
    end
  end
end