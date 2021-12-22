class AddCreatorToSbaApplications < ActiveRecord::Migration
  def change
    add_column :sba_applications, :creator_id, :integer

    SbaApplication.reset_column_information
    # Below migration takes 20 minutes to run in upper environments, moving the task to rake migration_support:add_creator_to_sba_applications
    SbaApplication.all.each do |app|
      app.update_attribute(:creator_id, app.organization.try(:default_user).try(:id))
    end

    Contributor.all.each do |c|
      if c.sub_application
        c.sub_application.update_attribute :creator_id, c.id
      end
    end
  end
end
