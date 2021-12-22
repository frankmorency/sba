module OpsSupport
  class SamValidationController < OpsSupportController
    before_action :require_ops_support
    before_action :set_duns_tin_mpin, only: [:index, :validate]


    def index
    end

    def show
      redirect_to ops_support_sam_validation_index_path
    end

    def validate
      @sam_org = MvwSamOrganization.find_by(duns: @duns)
      if @sam_org.present?
        @tin_validation_result = check_correctness(@sam_org, 'tin', @tin)
        @mpin_validation_result = check_correctness(@sam_org, 'mpin', @mpin)
      end
    end

    def set_duns_tin_mpin
      @duns, @tin, @mpin = params[:duns], params[:tin], params[:mpin]
    end

    def check_correctness(org, type, value)
      if type == "tin"
        if value.blank?
          return "Field left blank"
        elsif value == org&.tax_identifier_number
          return "Exact match"
        else
          return "Incorrect. Tax identifier type on file is '#{org&.tax_identifier_type}'"
        end
      elsif type == "mpin"
        if value.blank?
          return "Field left blank"
        elsif value == org&.mpin
          return "Exact match"
        elsif value.downcase == org&.mpin.downcase
          return "Mismatch due to letter case"
        else
          return "Incorrect."
        end
      end
    end

    protected
    
    def require_ops_support
      user_not_authorized unless current_user.can?(:ensure_ops_support)
    end
  end
end
