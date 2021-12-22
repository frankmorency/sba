class AddSanityToContributors < ActiveRecord::Migration
  def change
    add_column :contributors, :user_id, :integer
    add_column :contributors, :sub_application_id, :integer

    Contributor.reset_column_information

    Contributor.all.each do |c|
      c.update_attribute :sub_application_id, c.application_section.sub_application.try(:id) if c.application_section
      c.update_attribute :user_id, User.find_by(email: c.email).try(:id)
    end
  end
end
