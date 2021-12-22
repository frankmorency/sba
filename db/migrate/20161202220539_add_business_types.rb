class AddBusinessTypes < ActiveRecord::Migration
  def change
    
    BusinessType.create!(name: 'llc', display_name: 'Limited Liability Corporation')
    BusinessType.create!(name: 'corp', display_name: 'C-Corporation')
    BusinessType.create!(name: 's-corp', display_name: 'S-Corporation')
    BusinessType.create!(name: 'partnership', display_name: 'Partnership')
    BusinessType.create!(name: 'sole_prop', display_name: 'Sole Proprietorship')
  end
end
