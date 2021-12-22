module Api
  module V1
    class DunsNumbersController < BaseController
      
      respond_to :json

      def show
        name = MvwSamOrganization.get_name_by_duns(duns_number_param)
        @obj = { duns: duns_number_param, name: name }
      end

      def naics
         @codes = MvwSamOrganization.get_name_by_duns(duns_number_param)
      end

      private
        def duns_number_param
          params.require(:id)
        end
    end
  end
end