require 'feature_helper'

STATUS_TO_DUNS = {
    "approved" => "582976669",
    "withdrawn" => "588197983",
    "early_graduated" => "595621168",
    "graduated" => "588539248",
    "terminated" => "593793246",
    "suspended" => "595237256",
    "rejected" => "595237222"
}

feature 'BDMIS Reimport scenarios' do
  before do
    @graduate = create_user_vendor_admin(duns: STATUS_TO_DUNS['graduated'], business_name: 'The Graduate')
    @early_graduate = create_user_vendor_admin(duns: STATUS_TO_DUNS['early_graduated'], business_name: 'Doogie Howser LLC')
    @approved = create_user_vendor_admin(duns: STATUS_TO_DUNS['approved'], business_name: 'Greenlight LLC')
    @terminated = create_user_vendor_admin(duns: STATUS_TO_DUNS['terminated'], business_name: 'Arnie Inc')
    @withdrawn = create_user_vendor_admin(duns: STATUS_TO_DUNS['withdrawn'], business_name: 'Cash Money Allstars')
    @suspended = create_user_vendor_admin(duns: STATUS_TO_DUNS['suspended'], business_name: 'Cliffhanger')
    @rejected = create_user_vendor_admin(duns: STATUS_TO_DUNS['rejected'], business_name: 'Sams Catering')
    @do_supervisor = create_user_analyst(:sba_supervisor_8a_district_office)
    Questionnaire::EightAMigrated.load_from_csv!('spec/fixtures/bdmis_test/reimport_statuses')
  end

  scenario 'migrated applications should display on the vendor dashboard with the right status', js: true  do
    as_user @approved do
      visit '/vendor_admin/dashboard'
      within 'table#certifications' do
        should_have_content 'BDMIS Archive', 'Active', 'Certificate'
        should_not_have_content 'Graduated', 'Withdrawn', 'Terminated', 'Early Graduated'
      end
    end

    as_user @suspended do
      visit '/vendor_admin/dashboard'
      within 'table#certifications' do
        should_have_content 'BDMIS Archive', 'Active', 'Certificate'
        should_not_have_content 'Graduated', 'Withdrawn', 'Terminated', 'Early Graduated'
      end
    end

    as_user @terminated do
      visit '/vendor_admin/dashboard'
      within 'table#certifications' do
        should_have_content 'BDMIS Archive', 'Terminated', 'Certificate'
        should_not_have_content 'Active', 'Graduated', 'Withdrawn', 'Early Graduated'
      end
    end

    as_user @withdrawn do
      visit '/vendor_admin/dashboard'
      within 'table#certifications' do
        should_have_content 'BDMIS Archive', 'Withdrawn', 'Certificate'
        should_not_have_content 'Active', 'Graduated', 'Terminated', 'Early Graduated'
      end
    end

    as_user @graduate do
      visit '/vendor_admin/dashboard'
      within 'table#certifications' do
        should_have_content 'BDMIS Archive', 'Graduated', 'Certificate'
        should_not_have_content 'Active', 'Early Graduated', 'Withdrawn', 'Terminated'
      end
    end

    as_user @early_graduate do
      visit '/vendor_admin/dashboard'
      within 'table#certifications' do
        should_have_content 'BDMIS Archive', 'Early Graduated', 'Certificate'
        should_not_have_content 'Active', 'Withdrawn', 'Terminated'
      end
    end

    # as_user @rejected do
    #   visit '/vendor_admin/dashboard'
    #   within 'table#certifications' do
    #     should_have_content 'BDMIS Archive', 'BDMIS Rejected', 'Certificate'
    #     should_not_have_content 'Active', 'Graduated', 'Withdrawn', 'Early Graduated'
    #   end
    # end
  end

  scenario 'supervisor should only see active cases under unassigned cases', js: true do
    as_user @do_supervisor do
      visit '/'
      within 'table#unassigned_cases' do
        should_have_content @approved.organization.name, @suspended.organization.name
        should_not_have_content @early_graduate.organization.name, @graduate.organization.name, @terminated.organization.name, @withdrawn.organization.name
      end
    end
  end
end

