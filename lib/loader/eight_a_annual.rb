module Loader
  class EightAAnnual < Base
    def load!
      SbaApplication.transaction do
        finish_sub_app! 'eight_a_annual_review_eligibility'
        finish_sub_app! 'eight_a_annual_review_ownership'
        finish_sub_app! 'eight_a_annual_control'
        finish_sub_app! 'eight_a_annual_business_development'
      end
    end
  end
end