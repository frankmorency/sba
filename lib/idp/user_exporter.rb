require 'csv'

module Idp
  class UserExporter
    def initialize(filename=nil)
      @filename = filename || generate_filename
      @filepath = "idp_data/" + @filename
    end

    def run
      headers = %w(id email first_name last_name phone_number perspective)
      file_contents = CSV.generate do |csv|
        csv << headers
        User.all.each do |user|
          csv << [user.id, user.email, user.first_name, user.last_name, user.phone_number, perspective(user)]
        end
      end
      upload_to_s3(file_contents)
    end

    private
      def perspective(user)
        if user.max_id.present? || user.is_sba?
          "government"
        else
          "firm"
        end
      end

    def generate_filename
      "certify_users_export_#{DateTime.now.strftime('%Y_%m_%d_%H_%M_%S')}.csv"
    end

    def bucket
      bucket_name = ""
      if Rails.env.development?
        bucket_name = ENV['AWS_S3_BUCKET_NAME']
      else
        bucket_name = "sba-prod-external-data"
      end
    end

    def upload_to_s3(file_contents)
      # Uploads files with server_side_encryption: "AES256"
      if S3Service.new.upload_file(bucket, @filepath, file_contents)
        Rails.logger.info "Successfully uploaded #{@filepath} to S3 bucket #{bucket}."
        puts "Successfully uploaded #{@filepath} to S3 bucket #{bucket}."
      else
        Rails.logger.info "ERROR: Failed to upload #{@filepath} to S3 bucket #{bucket}."
        puts "ERROR: Failed to upload #{@filepath} to S3 bucket #{bucket}."
      end
    end
  end
end
