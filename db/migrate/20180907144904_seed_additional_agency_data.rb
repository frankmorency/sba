class SeedAdditionalAgencyData < ActiveRecord::Migration
  def up
    CSV.foreach(Rails.root.join('db', 'migrate', 'e8a', '13_new_agencies.csv'), headers: true) do |row|
      if AgencyOffice.exists?(name: row[0])
        puts "Agency #{row[0]} already exists. Skipping."
      else
        AgencyOffice.create(name: row[0], abbreviation: row[1])
      end
    end
  end

  def down
    CSV.foreach(Rails.root.join('db', 'migrate', 'e8a', '13_new_agencies.csv'), headers: true) do |row|
      if !AgencyOffice.exists?(name: row[0])
        puts "Agency #{row[0]} does not exists. Skipping delete."
      else
        AgencyOffice.find_by_name(row[0]).destroy
      end
    end
  end
end
