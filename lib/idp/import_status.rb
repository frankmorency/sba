require Rails.root.join("app/mailers/idp_mailer")

module Idp
  class ImportStatus

    def run
      response = get_stats

      if response.code != "200"
        Rails.logger.info "Idp::ImportStatusGenerator Error: IdP returned Status #{response.code}. Body #{response.body}."
        puts "Idp::ImportStatusGenerator Error: IdP returned Status #{response.code}. Body #{response.body}."
        return
      end

      email(response.body)
    end

    private

    def get_stats
      end_point = "migration_api/show_counts_all_counts" # IdP endpoint
      uri = URI(ENV['SBA_IDP_ISSUER'] + end_point)
      Net::HTTP.get_response(uri)
    end

    def email(report)
      IdpMailer.migration_report(recipient_emails, report).deliver_now
    end

    def recipient_emails
      if Rails.env.production?
        ["management@certify.sba.gov"]
      else
        ["sarlekar@enquizit.com"]
      end
    end
  end
end
