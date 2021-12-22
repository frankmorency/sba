class UpdateAccessRequestsForExistingUsers < ActiveRecord::Migration
  def change
    User.all.each do |user|
      if user.has_role?(:vendor_admin) || user.has_role?(:vendor_editor) && user.organizations.present?
          VendorRoleAccessRequest.create!(role: user.roles.first, organization: user.organizations.first, user: user)
      end
    end
  end
end
