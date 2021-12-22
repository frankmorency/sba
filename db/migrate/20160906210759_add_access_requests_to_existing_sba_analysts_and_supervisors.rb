class AddAccessRequestsToExistingSbaAnalystsAndSupervisors < ActiveRecord::Migration
  def change
    User.all.each do |user|
      if user.has_role?(:sba_supervisor) || user.has_role?(:sba_owner)
        SbaRoleAccessRequest.create!(role: user.roles.first,  user: user)
      end
    end
  end
end
