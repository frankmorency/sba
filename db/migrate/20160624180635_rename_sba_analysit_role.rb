class RenameSbaAnalysitRole < ActiveRecord::Migration
  def up
    r = Role.find_by_name("sba_analyst")
    unless r.nil?
      r.name = "sba_owner"
      r.save!
    end
  end

  def down
    r = Role.find_by_name("sba_owner")
    unless r.nil?
      r.name = "sba_analyst"
      r.save!
    end
  end
end
