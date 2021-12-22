module Custom
  class AmIEligible
    attr_accessor :questions, :edwosb_naics_codes, :wosb_naics_codes

    def initialize
      @questions = Questionnaire.get('am_i_eligible_v2').root_section.question_presentations.map do |q|
        {
            name: q.name,
            text: q.title,
            type: q.helpful_info['type'],
            expected: q.helpful_info['expected'],
            success: q.helpful_info['success'],
            failure: q.helpful_info['failure'],
            reason: q.helpful_info['reason'],
            requirements: q.helpful_info['requirements'],
            special_message: q.helpful_info['special_message'],
            details_file: File.exists?(Rails.root.join('app', 'views', 'helpful_info', q.name, "_am_i_eligible_one_pager")) ? 'am_i_eligible_v2' : 'default'
        }
      end

      @edwosb_naics_codes = CertificateType.get('edwosb').eligible_naic_codes.map(&:naic_code)
      @wosb_naics_codes = CertificateType.get('wosb').eligible_naic_codes.map(&:naic_code)
    end

    def as_json(options = {})
      {
          questions: @questions,
          edwosb_naics_codes: @edwosb_naics_codes,
          wosb_naics_codes: @wosb_naics_codes
      }
    end
  end
end