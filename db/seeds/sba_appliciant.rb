password = "Not@allthepassword1"

# Create User with SBA Application
(1..3).each do |i|
    user = User.new(
                    first_name: "SBA", last_name: "Appliciant", 
                    email: "sba_appliciant_#{i}@mailinator.com", 
                    password: password, 
                    password_confirmation: password,
                    confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{i}",
                    confirmed_at: Time.now)
    user.skip_confirmation!
    user.save!

    # 1 = Missing SAM record, 2 = Valid SAM record, 3 = SAM Record with D
    duns_number = i == 1 ? "999999999" : i == 2 ? "986643337" : "994398723"
    # Map User to Organization with Valid SAM Record DUNS number 988795221
    org = Organization.create!(duns_number: duns_number, tax_identifier: "123456789", tax_identifier_type: "EIN", business_type: "sole_prop")
    # Get Document Type (Third Party Certification)
    dt = DocumentType.find(1)
    # Create documentation with org id
    Document.create!(organization_id: org.id, stored_file_name: Time.now.to_i.to_s, original_file_name: "qa_automation.pdf", document_type: dt, is_active: true, user_id: user.id)
    # Add user to role = vendor_admin
    VendorRoleAccessRequest.add_first_user(user, org, :vendor_admin)
    # Get 8a Certificate Type 
    certificate_type = CertificateType.find_by(name: 'eight_a')
    questionnaire = certificate_type.questionnaire(SbaApplication::INITIAL)
    
    #Create 8a Initial Application
    options = {kind: 'initial'}
    sba_application  = questionnaire.start_application(org, options)
    sba_application.creator = user
    sba_application.save!
    
    #Fill out 8a Initial Application questionnaire
    Loader::EightA.load sba_application.id
    Loader::EightASubApp.load sba_application.id + 3
    
    #Submit 8a Initial Application
    sba_application.submit!    
end

Chewy::RakeHelper.update_index('cases_v2_index')