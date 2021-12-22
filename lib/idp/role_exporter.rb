require 'csv'

module Idp
  class RoleExporter < UserExporter
    def initialize(filename=nil)
      @filename = filename || generate_filename
      @filepath = "idp_data/" + @filename
    end

    def run
      headers = %w(id email first_name last_name phone_number perspective role)
      file_contents = CSV.generate do |csv|
        csv << headers
        User.all.each do |user|
          csv << [user.id, user.email, user.first_name, user.last_name, user.phone_number, perspective(user),
                  role(user)]
        end
      end
      upload_to_s3(file_contents)
    end

    private

    def generate_filename
      "certify_user_roles_export_#{DateTime.now.strftime('%Y_%m_%d_%H_%M_%S')}.csv"
    end

    def role(user)
      if user.roles.blank?
        generate_role(user) # Assigns a temporary role label explaining why the role is missing
      else
        user.roles.map(&:name).join(",")
      end
    end

    def generate_role(user)
      if user.is_sba_or_ops? || (['.gov', '.mil', '.fed.us'].include? user.email.split('@').last)
        "analyst_without_role"
      elsif user.confirmed_at.blank?
        "user_without_confirmed_email"
      elsif user.organization.blank?
        "vendor_user_without_organization"
      end
    end
  end
end
