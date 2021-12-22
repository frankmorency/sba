class UpdateAgencyNames < ActiveRecord::Migration
  def change
    AgencyOffice.find_by_name('Agriculture Department').update_column(:name, 'Department of Agriculture')
    AgencyOffice.find_by_name('Commerce Department').update_column(:name, 'Department of Commerce')
    AgencyOffice.find_by_name('Defense Department').update_column(:name, 'Department of Defense')
    AgencyOffice.find_by_name('Education Department').update_column(:name, 'Department of Education')
    AgencyOffice.find_by_name('Energy Department').update_column(:name, 'Department of Energy')
    AgencyOffice.find_by_name('Health and Human Services Department').update_column(:name, 'Department of Health and Human Services')
    AgencyOffice.find_by_name('Homeland Security Department').update_column(:name, 'Department of Homeland Security')
    AgencyOffice.find_by_name('Housing and Urban Development Department').update_column(:name, 'Department of Housing and Urban Development')
    AgencyOffice.find_by_name('Interior Department').update_column(:name, 'Department of the Interior')
    AgencyOffice.find_by_name('Justice Department').update_column(:name, 'Department of Justice')
    AgencyOffice.find_by_name('Labor Department').update_column(:name, 'Department of Labor')
    AgencyOffice.find_by_name('State Department').update_column(:name, 'Department of State')
    AgencyOffice.find_by_name('Transportation Department').update_column(:name, 'Department of Transportation')
    AgencyOffice.find_by_name('Treasury Department').update_column(:name, 'Department of the Treasury')
    AgencyOffice.find_by_name('Veterans Affairs Department').update_column(:name, 'Department of Veterans Affairs')
  end
end
