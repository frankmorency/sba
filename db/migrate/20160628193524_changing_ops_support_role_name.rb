class ChangingOpsSupportRoleName < ActiveRecord::Migration
  def up
    r = Role.find_by_name 'ops_support'
    unless r.nil?
      r.name = "sba_ops_support"
      r.save!
    end
  end

  def down
    r = Role.find_by_name 'sba_ops_support'
    unless r.nil?
      r.name = "ops_support"
      r.save!
    end
  end
end