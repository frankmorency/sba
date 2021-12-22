module Loader
  class EightA < Base
    def load!
      SbaApplication.transaction do
        finish_sub_app! 'eight_a_eligibility'
        finish_sub_app! 'eight_a_business_ownership'
        finish_sub_app! 'eight_a_character'
        finish_sub_app! 'eight_a_potential_for_success'
        finish_sub_app! 'eight_a_control'
      end
    end
  end
end