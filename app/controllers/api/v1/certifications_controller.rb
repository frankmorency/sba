module Api
  module V1
    class CertificationsController < ActionController::Base

      respond_to :json

      def index
        # params['before'] - retrieve those that changed before this time
        # params['after'] - retrieve those that changed after this time
        allowed_params = params.permit(:after, :before)
        @objs = index_data(allowed_params)
      end

      private

        def index_data(filters)
          # we need to allow paging over organizations that have certifications that fall into the
          # given date range
          orgs = Organization
          orgs = orgs.with_certificates_updated_after(filters[:after]) if filters[:after]
          orgs = orgs.with_certificates_updated_before(filters[:before]) if filters[:before]

          orgs.all.map do |org|
            certifications = org.certificates.not_expired.with_active_state
            {
              duns: org.duns_number,
              certifications: certifications.uniq.map(&method(:certification_details))
            }
          end.compact
        end

        def certification_details(certification)
          {
            type: certification.certificate_type.title,
            started_on: certification.issue_date,
            ended_on: certification.expiry_date
          }
        end
    end
  end
end
