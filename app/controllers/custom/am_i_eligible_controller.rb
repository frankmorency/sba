module Custom
  class AmIEligibleController < ApplicationController
    before_action   :set_public_flag

    def new
      @am_i_eligible = Custom::AmIEligible.new
      @am_i_eligible
    end

    def prepare
    end
  end
end
