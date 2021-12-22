FactoryBot.define do
  factory :sba_analyst_wosb_role, class: Role do
    name 'sba_analyst_wosb'
  end

  factory :sba_supervisor_wosb_role, class: Role do
    name 'sba_supervisor_wosb'
  end

  factory :admin_role, class: Role do
    name 'admin'
  end

  factory :vendor_admin_role, class: Role do
    name 'vendor_admin'
  end

  factory :contributor_role, class: Role do 
    name 'contributor'
  end
  
  factory :federal_contracting_officer_role, class: Role do
    name 'federal_contracting_officer'
  end

  factory :sba_supervisor_mpp_role, class: Role do
    name 'sba_supervisor_mpp'
  end

  factory :sba_analyst_mpp_role, class: Role do
    name 'sba_analyst_mpp'
  end

  factory :sba_ops_support_admin_role, class: Role do
    name 'sba_ops_support_admin'
  end
  
  factory :sba_ops_support_staff_role, class: Role do
    name 'sba_ops_support_staff'
  end
    
  factory :vendor_editor_role, class: Role do
    name 'vendor_editor'
  end

  %w(sba_analyst_8a_cods sba_analyst_8a_hq_program sba_supervisor_8a_hq_aa sba_analyst_8a_district_office).each do |role|
    factory :"#{role}_role", class: Role do
      name role
    end
  end

  %w(sba_supervisor_8a_cods sba_supervisor_8a_hq_program sba_supervisor_8a_district_office).each do |role|
    factory :"#{role}_role", class: Role do
      name role
    end
  end

  %w(sba_director_8a_district_office sba_deputy_director_8a_district_office).each do |role|
    factory :"#{role}_role", class: Role do
      name role
    end
  end
end
