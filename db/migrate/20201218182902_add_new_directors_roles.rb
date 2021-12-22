class AddNewDirectorsRoles < ActiveRecord::Migration
  def change
    list = %w(sba_director_8a_district_office
              sba_deputy_director_8a_district_office)

    list.each do |name|
      Role.create!(name: name)
    end
  end
end
