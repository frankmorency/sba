#TODO: This is to add users and org temporarily. Should be commented out or removed before deploying to staging or prod.
# Rails.logger.error "Activity log service is down: #{e.message}"
require "csv"

if %w(dev docker development test qa demo training training_admin).include? Rails.env
  txt_file_path = "db/SAM_Sample_Data.csv"
  Rails.logger.info "Truncating sam_organizations, injecting new ones from #{txt_file_path}"
  ActiveRecord::Base.connection.execute("TRUNCATE sam_organizations;")
  CSV.read(txt_file_path).each do |row|
    new_row = row[0].split("|")
    new_row.pop
    new_row.map! { |element| "'#{element}'" }
    insert_values = new_row.join(", ")
    ActiveRecord::Base.connection.execute("INSERT INTO sam_organizations VALUES (#{insert_values})")
  end
  MvwSamOrganization.refresh
end

dt = DocumentType.find(1)

# Creating a few vendor editors to be associated with some biz later down on this file.
Rails.logger.info "Creating a few vendor editors to be associated with some biz later down on this file."
(1..5).each do |i|
  Rails.logger.info i
  if Feature.active?(:idp)
    user = User.new(first_name: "VendorEditor#{i}", last_name: "X", email: "vendor_editor#{i}@mailinator.com", password: "Not@allthepassword1", confirmation_token: "CgmvRKDtqr8349nxri3oeuSf4oAK8YVendorEditor_#{i}", confirmed_at: Time.now)
  else
    user = User.new(first_name: "VendorEditor#{i}", last_name: "X", email: "vendor_editor#{i}@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "CgmvRKDtqr8349nxri3oeuSf4oAK8YVendorEditor_#{i}", confirmed_at: Time.now)
  end

  user.skip_confirmation!
  user.save!
end
vendor_editors_list = User.all # at this point we should have 5 users with no association that will become vendor editors

# List of no roles users created to test the association of vendor roles.
Rails.logger.info "List of no roles users created to test the association of vendor roles."
(1..25).each do |i|
  Rails.logger.info i
  if Feature.active?(:idp)
    user = User.new(first_name: "blank#{i}", last_name: "Steve", email: "norole#{i}@mailinator.com", password: "Not@allthepassword1", confirmation_token: "CgmvRKDtqr8349nxri3oeuSf4oAK8YNoRole_#{i}", confirmed_at: Time.now)
  else
    user = User.new(first_name: "blank#{i}", last_name: "Steve", email: "norole#{i}@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "CgmvRKDtqr8349nxri3oeuSf4oAK8YNoRole_#{i}", confirmed_at: Time.now)
  end
  user.skip_confirmation!
  user.save!
end

#1. Meaningful names
Rails.logger.info "Creating John X user"
i = 100
if Feature.active?(:idp)
  user = User.new(first_name: "John", last_name: "X", email: "john@mailinator.com", password: "Not@allthepassword1", confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{i}", confirmed_at: Time.now)
else
  user = User.new(first_name: "John", last_name: "X", email: "john@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{i}", confirmed_at: Time.now)
end
user.skip_confirmation!
user.save!
org = Organization.create!(duns_number: "111292429", tax_identifier: "123456789", tax_identifier_type: "EIN", business_type: "llc")
document = Document.create!(organization_id: org.id, stored_file_name: Time.now.to_i.to_s, original_file_name: "qa_automation.pdf", document_type: dt, is_active: true, user_id: user.id)
VendorRoleAccessRequest.add_first_user(user, org, :vendor_admin)

Rails.logger.info "Creating Ricky X user"
i = 200
if Feature.active?(:idp)
  user = User.new(first_name: "Ricky", last_name: "X", email: "ricky@mailinator.com", password: "Not@allthepassword1", confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{i}", confirmed_at: Time.now)
else
  user = User.new(first_name: "Ricky", last_name: "X", email: "ricky@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{i}", confirmed_at: Time.now)
end
user.skip_confirmation!
user.save!
org = Organization.create!(duns_number: "111419538", tax_identifier: "123456789", tax_identifier_type: "EIN", business_type: "corp")
document = Document.create!(organization_id: org.id, stored_file_name: Time.now.to_i.to_s, original_file_name: "qa_automation.pdf", document_type: dt, is_active: true, user_id: user.id)
VendorRoleAccessRequest.add_first_user(user, org, :vendor_admin)

Rails.logger.info "Creating Mark X user"
i = 300
if Feature.active?(:idp)
  user = User.new(first_name: "Mark", last_name: "X", email: "mark@mailinator.com", password: "Not@allthepassword1", confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{i}", confirmed_at: Time.now)
else
  user = User.new(first_name: "Mark", last_name: "X", email: "mark@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{i}", confirmed_at: Time.now)
end
user.skip_confirmation!
user.save!
org = Organization.create!(duns_number: "646166252", tax_identifier: "123456789", tax_identifier_type: "EIN", business_type: "partnership")
document = Document.create!(organization_id: org.id, stored_file_name: Time.now.to_i.to_s, original_file_name: "qa_automation.pdf", document_type: dt, is_active: true, user_id: user.id)
VendorRoleAccessRequest.add_first_user(user, org, :vendor_admin)

Rails.logger.info "Creating Malcom (sic) X user"
i = 400
if Feature.active?(:idp)
  user = User.new(first_name: "Malcom", last_name: "X", email: "malcolm@mailinator.com", password: "Not@allthepassword1", confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{i}", confirmed_at: Time.now)
else
  user = User.new(first_name: "Malcom", last_name: "X", email: "malcolm@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{i}", confirmed_at: Time.now)
end
user.skip_confirmation!
user.save!
org = Organization.create!(duns_number: "648367713", tax_identifier: "123456789", tax_identifier_type: "EIN", business_type: "sole_prop")
document = Document.create!(organization_id: org.id, stored_file_name: Time.now.to_i.to_s, original_file_name: "qa_automation.pdf", document_type: dt, is_active: true, user_id: user.id)
VendorRoleAccessRequest.add_first_user(user, org, :vendor_admin)

Rails.logger.info "Creating Turkey X user"
i = 401
if Feature.active?(:idp)
  user = User.new(first_name: "Turkey", last_name: "X", email: "turkey@mailinator.com", password: "Not@allthepassword1", confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{i}", confirmed_at: Time.now)
else
  user = User.new(first_name: "Turkey", last_name: "X", email: "turkey@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{i}", confirmed_at: Time.now)
end
user.skip_confirmation!
user.save!
org = Organization.create!(duns_number: "912999391", tax_identifier: "123456789", tax_identifier_type: "EIN", business_type: "sole_prop")
document = Document.create!(organization_id: org.id, stored_file_name: Time.now.to_i.to_s, original_file_name: "qa_automation.pdf", document_type: dt, is_active: true, user_id: user.id)
VendorRoleAccessRequest.add_first_user(user, org, :vendor_admin)

Rails.logger.info "Creating Robin X user"
i = 402
if Feature.active?(:idp)
  user = User.new(first_name: "Robin", last_name: "X", email: "robin@mailinator.com", password: "Not@allthepassword1", confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{i}", confirmed_at: Time.now)
else
  user = User.new(first_name: "Robin", last_name: "X", email: "robin@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{i}", confirmed_at: Time.now)
end
user.skip_confirmation!
user.save!
org = Organization.create!(duns_number: "929939873", tax_identifier: "123456789", tax_identifier_type: "EIN", business_type: "sole_prop")
document = Document.create!(organization_id: org.id, stored_file_name: Time.now.to_i.to_s, original_file_name: "qa_automation.pdf", document_type: dt, is_active: true, user_id: user.id)
VendorRoleAccessRequest.add_first_user(user, org, :vendor_admin)

Rails.logger.info "Creating Eagle X user"
i = 403
if Feature.active?(:idp)
  user = User.new(first_name: "Eagle", last_name: "X", email: "eagle@mailinator.com", password: "Not@allthepassword1", confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{i}", confirmed_at: Time.now)
else
  user = User.new(first_name: "Eagle", last_name: "X", email: "eagle@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{i}", confirmed_at: Time.now)
end

user.skip_confirmation!
user.save!
org = Organization.create!(duns_number: "962766844", tax_identifier: "123456789", tax_identifier_type: "EIN", business_type: "sole_prop")
document = Document.create!(organization_id: org.id, stored_file_name: Time.now.to_i.to_s, original_file_name: "qa_automation.pdf", document_type: dt, is_active: true, user_id: user.id)
VendorRoleAccessRequest.add_first_user(user, org, :vendor_admin)

Rails.logger.info "Creating Johnny Admin user"
i = 500
if Feature.active?(:idp)
  user = User.new(first_name: "Johnny", last_name: "Admin", email: "admin@mailinator.com", password: "Not@allthepassword1", confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{i}", confirmed_at: Time.now)
else
  user = User.new(first_name: "Johnny", last_name: "Admin", email: "admin@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{i}", confirmed_at: Time.now)
end
user.skip_confirmation!
user.roles_map = { "Legacy" => { "ADMIN" => ["admin"] } }
user.save!

Rails.logger.info "Creating Deric Vendor Corporation user"
i = 501
user = User.new(first_name: "Deric", last_name: "Vendor", email: "deric.corporation@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{i}", confirmed_at: Time.now)
user.skip_confirmation!
user.save!
org = Organization.create!(duns_number: "144291293", tax_identifier: "123456789", tax_identifier_type: "EIN", business_type: "corp")
document = Document.create!(organization_id: org.id, stored_file_name: Time.now.to_i.to_s, original_file_name: "qa_automation.pdf", document_type: dt, is_active: true, user_id: user.id)
VendorRoleAccessRequest.add_first_user(user, org, :vendor_admin)

Rails.logger.info "Creating Deric Vendor Sole Pro user"
i = 502
user = User.new(first_name: "Deric", last_name: "Vendor", email: "deric.soleproprietor@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{i}", confirmed_at: Time.now)
user.skip_confirmation!
user.save!
org = Organization.create!(duns_number: "123456789", tax_identifier: "123456789", tax_identifier_type: "EIN", business_type: "sole_prop")
document = Document.create!(organization_id: org.id, stored_file_name: Time.now.to_i.to_s, original_file_name: "qa_automation.pdf", document_type: dt, is_active: true, user_id: user.id)
VendorRoleAccessRequest.add_first_user(user, org, :vendor_admin)

Rails.logger.info "Creating WOSB Analysts"
#2. WOSB Analysts
(1..5).each do |i|
  Rails.logger.info i
  if Feature.active?(:idp)
    user = User.new(first_name: "Analyst#{i}", last_name: "X", email: "analyst#{i}@mailinator.com", password: "Not@allthepassword1", confirmation_token: "CgmvRKDtqr8349nxri3oeuSf4oAK8Y_#{i}", confirmed_at: Time.now, max_id: "B12345678-Analyst-wosb-#{i}")
  else
    user = User.new(first_name: "Analyst#{i}", last_name: "X", email: "analyst#{i}@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "CgmvRKDtqr8349nxri3oeuSf4oAK8Y_#{i}", confirmed_at: Time.now, max_id: "B12345678-Analyst-wosb-#{i}")
  end
  user.skip_confirmation!
  user.roles_map = { "Legacy" => { "WOSB" => ["analyst"], "EDWOSB" => ["analyst"] } }
  user.save!
end

Rails.logger.info "Creating MPP Analysts"
#2. MPP Analysts
(1..5).each do |i|
  Rails.logger.info i
  if Feature.active?(:idp)
    user = User.new(first_name: "Analyst#{i}", last_name: "MPP", email: "mpp_analyst#{i}@mailinator.com", password: "Not@allthepassword1", confirmation_token: "mppCgmvRKDtqr8349nxri3oeuSf4oAK8Y_#{i}", confirmed_at: Time.now, max_id: "B12345678-Analyst-MPP-#{i}")
  else
    user = User.new(first_name: "Analyst#{i}", last_name: "MPP", email: "mpp_analyst#{i}@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "mppCgmvRKDtqr8349nxri3oeuSf4oAK8Y_#{i}", confirmed_at: Time.now, max_id: "B12345678-Analyst-MPP-#{i}")
  end
  user.skip_confirmation!
  user.roles_map = { "Legacy" => { "MPP" => ["analyst"] } }
  user.save!
end

Rails.logger.info "Creating 8a Analysts"
#2. 8a Analysts
(1..5).each do |i|
  Rails.logger.info i
  if Feature.active?(:idp)
    user = User.new(first_name: "Analyst#{i}", last_name: "8a", email: "8a_analyst#{i}@mailinator.com", password: "Not@allthepassword1", confirmation_token: "Eight-A-CgmvRKDtqr8349nxri3oeuSf4oAK8Y_#{i}", confirmed_at: Time.now, max_id: "B12345678-Analyst-8A-#{i}")
  else
    user = User.new(first_name: "Analyst#{i}", last_name: "8a", email: "8a_analyst#{i}@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "Eight-A-CgmvRKDtqr8349nxri3oeuSf4oAK8Y_#{i}", confirmed_at: Time.now, max_id: "B12345678-Analyst-8A-#{i}")
  end
  user.skip_confirmation!
  user.roles_map = { "Legacy" => { "8a" => ["analyst"] } }
  user.save!
end

Rails.logger.info "Sample user from max.gov requesting the 'sba_analyst/owner/supervisor' role (US1130)"
#2 Sample user from max.gov requesting the 'sba_analyst/owner/supervisor' role (US1130)
(1..50).each do |i|
  Rails.logger.info i
  user = User.new(first_name: "Max Analyst#{i}",
                  last_name: "X",
                  email: "max_analyst#{i}@mailinator.com",
                  password: "Not@allthepassword1",
                  password_confirmation: "Not@allthepassword1",
                  confirmation_token: "CgmvRKDtqr8349nxri3oeuSf4oAK8X_#{i}",
                  # This user is max.gov user
                  max_id: "B12345678-#{i}",
                  max_agency: "NSA",
                  max_first_name: "Max Analyst#{i}",
                  max_last_name: "MAX_LAST_NAME",
                  confirmed_at: Time.now)
  user.skip_confirmation!
  user.roles_map = nil
  user.save!
end

Rails.logger.info "Creating COs"
#3. COs
(1..10).each do |i|
  Rails.logger.info i
  if Feature.active?(:idp)
    user = User.new(first_name: "CO#{i}", last_name: "X", email: "co#{i}@mailinator.com", password: "Not@allthepassword1", confirmation_token: "CgmvRKDtqr83cbirfjkerhi3oeuSf4oAK8Y_#{i}", confirmed_at: Time.now, max_id: "A12345678-#{i}", max_agency: "NSA", max_first_name: "CO#{i}", max_last_name: "MAX_LAST_NAME")
  else
    user = User.new(first_name: "CO#{i}", last_name: "X", email: "co#{i}@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "CgmvRKDtqr83cbirfjkerhi3oeuSf4oAK8Y_#{i}", confirmed_at: Time.now, max_id: "A12345678-#{i}", max_agency: "NSA", max_first_name: "CO#{i}", max_last_name: "MAX_LAST_NAME")
  end
  user.skip_confirmation!
  user.save!
end

Rails.logger.info "Creating Ops Support Staff users"
# Ops Support users
(1..5).each do |i|
  Rails.logger.info i
  if Feature.active?(:idp)
    user = User.new(first_name: "ops_support_#{i}", last_name: "Staff", email: "staff_opssupport_#{i}@mailinator.com", password: "Not@allthepassword1", confirmation_token: "CgmvRKDtqr8349nxri3oeuSf4oAK8YOpsRole_#{i}", confirmed_at: Time.now, max_id: "A12345678-ops-support-staff-#{i}")
  else
    user = User.new(first_name: "ops_support_#{i}", last_name: "Staff", email: "staff_opssupport_#{i}@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "CgmvRKDtqr8349nxri3oeuSf4oAK8YOpsRole_#{i}", confirmed_at: Time.now, max_id: "A12345678-ops-support-staff-#{i}")
  end

  user.skip_confirmation!
  user.roles_map = { "Legacy" => { "SUPPORT" => ["staff"] } }
  user.save!
end

Rails.logger.info "Creating Ops Support Admin users"
# Ops Support users
(1..5).each do |i|
  Rails.logger.info i
  if Feature.active?(:idp)
    user = User.new(first_name: "ops_support_#{i}", last_name: "Admin", email: "admin_opssupport_#{i}@mailinator.com", password: "Not@allthepassword1", confirmation_token: "sba_ops_support_admin_CgmvRKDtqr8349nxri3oeuSf4oAK8YOpsRole_#{i}", confirmed_at: Time.now, max_id: "A12345678-ops-support-admin-#{i}")
  else
    user = User.new(first_name: "ops_support_#{i}", last_name: "Admin", email: "admin_opssupport_#{i}@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "sba_ops_support_admin_CgmvRKDtqr8349nxri3oeuSf4oAK8YOpsRole_#{i}", confirmed_at: Time.now, max_id: "A12345678-ops-support-admin-#{i}")
  end
  user.skip_confirmation!
  user.roles_map = { "Legacy" => { "SUPPORT" => ["admin"] } }
  user.save!
end

Rails.logger.info "Creating WOSB Sba Supervisor users"
# WOSB Sba Supervisor users
(1..5).each do |i|
  Rails.logger.info i
  if Feature.active?(:idp)
    user = User.new(first_name: "sba_supervisor_wosb_#{i}", last_name: "WOSB", email: "sba_supervisor_wosb_#{i}@mailinator.com", password: "Not@allthepassword1", confirmation_token: "CgmvRKDtqr8349nxri3oeuSf4oAK8YSbaSupervisor_#{i}", confirmed_at: Time.now, max_id: "A12345678-supervisor-wosb-#{i}")
  else
    user = User.new(first_name: "sba_supervisor_wosb_#{i}", last_name: "WOSB", email: "sba_supervisor_wosb_#{i}@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "CgmvRKDtqr8349nxri3oeuSf4oAK8YSbaSupervisor_#{i}", confirmed_at: Time.now, max_id: "A12345678-supervisor-wosb-#{i}")
  end

  user.skip_confirmation!
  user.roles_map = { "Legacy" => { "WOSB" => ["supervisor"], "EDWOSB" => ["supervisor"] } }
  user.save!
end

Rails.logger.info "Creating MPP Sba Supervisor users"
# MPP Sba Supervisor users
(1..5).each do |i|
  Rails.logger.info i
  if Feature.active?(:idp)
    user = User.new(first_name: "sba_supervisor_#{i}", last_name: "MPP", email: "sba_supervisor_mpp_#{i}@mailinator.com", password: "Not@allthepassword1", confirmation_token: "mppCgmvRKDtqr8349nxri3oeuSf4oAK8YSbaSupervisor_#{i}", confirmed_at: Time.now, max_id: "B12345678-SupervisorMpp-#{i}")
  else
    user = User.new(first_name: "sba_supervisor_#{i}", last_name: "MPP", email: "sba_supervisor_mpp_#{i}@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "mppCgmvRKDtqr8349nxri3oeuSf4oAK8YSbaSupervisor_#{i}", confirmed_at: Time.now, max_id: "B12345678-SupervisorMpp-#{i}")
  end
  user.skip_confirmation!
  user.roles_map = { "Legacy" => { "MPP" => ["supervisor"] } }
  user.save!
end

Rails.logger.info "Creating 8A Sba Supervisor users"
# 8A Sba Supervisor users
(1..5).each do |i|
  Rails.logger.info i
  if Feature.active?(:idp)
    user = User.new(first_name: "sba_supervisor_#{i}", last_name: "8A", email: "sba_supervisor_8a_#{i}@mailinator.com", password: "Not@allthepassword1", confirmation_token: "eight-a-CgmvRKDtqr8349nxri3oeuSf4oAK8YSbaSupervisor_#{i}", confirmed_at: Time.now, max_id: "B12345678-Supervisor8a-#{i}")
  else
    user = User.new(first_name: "sba_supervisor_#{i}", last_name: "8A", email: "sba_supervisor_8a_#{i}@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "eight-a-CgmvRKDtqr8349nxri3oeuSf4oAK8YSbaSupervisor_#{i}", confirmed_at: Time.now, max_id: "B12345678-Supervisor8a-#{i}")
  end
  user.skip_confirmation!
  user.roles_map = { "Legacy" => { "8a" => ["supervisor"] } }
  user.save!
end

Rails.logger.info "Creating 8A Sba District Director users"
# 8A Sba District Director users
(1..5).each do |i|
  Rails.logger.info i
  if Feature.active?(:idp)
    user = User.new(first_name: "sba_dd_#{i}", last_name: "8A", email: "sba_dd_8a_#{i}@mailinator.com", password: "Not@allthepassword1", confirmation_token: "eight-a-CgmvRKDtqr8349nxri3oeuSf4oAK8YSbaSupervisor_#{i}", confirmed_at: Time.now, max_id: "B12345678-Supervisor8a-#{i}")
  else
    user = User.new(first_name: "sba_dd_#{i}", last_name: "8A", email: "sba_dd_8a_#{i}@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "eight-a-CgmvRKDtqr8349nxri3oeuSf4oAK8YSbaDirector_#{i}", confirmed_at: Time.now, max_id: "B12345678-Supervisor8a-#{i}")
  end

  user.skip_confirmation!
  user.roles_map = { "DISTRICT_OFFICE_DIRECTOR" => { "8a" => ["supervisor"] } }
  user.save!
end

Rails.logger.info "Creating 8A Sba Deputy District Director users"
# 8A Sba Deputy District Director users
(1..5).each do |i|
  Rails.logger.info i
  if Feature.active?(:idp)
    user = User.new(first_name: "sba_ddd_#{i}", last_name: "8A", email: "sba_ddd_8a_#{i}@mailinator.com", password: "Not@allthepassword1", confirmation_token: "eight-a-CgmvRKDtqr8349nxri3oeuSf4oAK8YSbaSupervisor_#{i}", confirmed_at: Time.now, max_id: "B12345678-Supervisor8a-#{i}")
  else
    user = User.new(first_name: "sba_ddd_#{i}", last_name: "8A", email: "sba_ddd_8a_#{i}@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "eight-a-CgmvRKDtqr8349nxri3oeuSf4oAK8YSbaDeputyDirector_#{i}", confirmed_at: Time.now, max_id: "B12345678-Supervisor8a-#{i}")
  end

  user.skip_confirmation!
  user.roles_map = { "DISTRICT_OFFICE_DEPUTY_DIRECTOR" => { "8a" => ["supervisor"] } }
  user.save!
end

qa_users_file_path = "db/QA_Seed_Users.csv"
Rails.logger.info "Creating users and organizations from file: #{qa_users_file_path}"
CSV.read(qa_users_file_path).each do |row|
  user = User.new(first_name: "QA", last_name: "User", email: row[0], password: row[1], password_confirmation: row[1], confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_#{row[0]}", confirmed_at: Time.now)
  user.skip_confirmation!
  user.save!
  org = Organization.create!(duns_number: row[2], tax_identifier: row[3], tax_identifier_type: "EIN", business_type: row[5])
  document = Document.create!(organization_id: org.id, stored_file_name: Time.now.to_i.to_s, original_file_name: "qa_automation.pdf", document_type: dt, is_active: true, user_id: user.id)
  VendorRoleAccessRequest.add_first_user(user, org, :vendor_admin)
end

title_panel = "Title panel"
left_panel = "left panel"
right_panel = "right panel"
Rails.logger.info "Creating Help Page"
HelpPage.create!(title: title_panel, left_panel: left_panel, right_panel: right_panel)

if %w(dev development test qa demo).include? Rails.env
  # Get all unclaimed Orgs and seed it for QA team
  Rails.logger.info "Get all unclaimed Orgs and seed it for QA team"
  sam_orgs = MvwSamOrganization.where(tax_identifier_type: ["EIN", "SSN"], sam_extract_code: "A").where.not(duns: Organization.all.select("duns_number"))
  (1..200).each do |i|
    Rails.logger.info i
    if Feature.active?(:idp)
      user = User.new(first_name: "QA #{i}", last_name: "Last#{i}", email: "qa#{i}@mailinator.com", password: "Not@allthepassword1", confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_abc#{i}", confirmed_at: Time.now)
    else
      user = User.new(first_name: "QA #{i}", last_name: "Last#{i}", email: "qa#{i}@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "CgmvRKDtqoeuSf4oAK8Y_abc#{i}", confirmed_at: Time.now)
    end

    user.skip_confirmation!
    user.save!
    org = Organization.create!(duns_number: sam_orgs[i].duns, tax_identifier: sam_orgs[i].tax_identifier_number, tax_identifier_type: sam_orgs[i].tax_identifier_type, business_type: "corp")
    document = Document.create!(organization_id: org.id, stored_file_name: Time.now.to_i.to_s, original_file_name: "qa_automation.pdf", document_type: dt, is_active: true, user_id: user.id)
    VendorRoleAccessRequest.add_first_user(user, org, :vendor_admin)
  end
end

################# New 8(a) Roles that use Buisness Units.
dt = DutyStation.find(1)
dt_sf = DutyStation.find_by(name: "San Francisco")
dt_pily = DutyStation.find_by(name: "Philadelphia")

analyst = %w(
  sba_analyst_8a_cods
  sba_analyst_8a_hq_program
  sba_analyst_8a_size
  sba_analyst_8a_ops
  sba_analyst_8a_district_office
  sba_analyst_8a_hq_ce
  sba_analyst_8a_hq_legal
  sba_analyst_8a_oig
)

analyst.each do |name|
  splited = name.split("_8a_")
  bu = splited[1]

  Rails.logger.info "Create 8(a) Analysts with duty stations"
  #2. 8(a) Analysts
  (1..5).each do |i|
    Rails.logger.info i
    if Feature.active?(:idp)
      user = User.new(first_name: "Analyst#{i}", last_name: name.humanize, email: "#{name}_#{i}@mailinator.com", password: "Not@allthepassword1", confirmation_token: "Eight-A-CgmvRKDtqr8349nxri3oeuSf4oAK8Y_#{name}_#{i}", confirmed_at: Time.now, max_id: "B12345678_#{name}_#{i}")
    else
      user = User.new(first_name: "Analyst#{i}", last_name: name.humanize, email: "#{name}_#{i}@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "Eight-A-CgmvRKDtqr8349nxri3oeuSf4oAK8Y_#{name}_#{i}", confirmed_at: Time.now, max_id: "B12345678_#{name}_#{i}")
    end

    user.skip_confirmation!
    user.roles_map = { "#{bu}".upcase => { "8a" => ["analyst"] } }
    user.duty_stations << dt
    user.duty_stations << dt_sf
    user.duty_stations << dt_pily
    user.save!

    business_unit = BusinessUnit.find_by_name "#{bu}".upcase
    user.office_locations.create!(business_unit_id: business_unit.id)

    # Each Dutty Station needs to have only one AR this is because each request is sent to a separate supervisor.
    ar = SbaRoleAccessRequest.create!(roles_map: { "#{bu}".upcase => { "8a" => ["analyst"] } }, user_id: user.id)
    ar.update_attributes!(status: "accepted")
    ar.duty_stations << dt
    ar.save!

    ar = SbaRoleAccessRequest.create!(roles_map: { "#{bu}".upcase => { "8a" => ["analyst"] } }, user_id: user.id)
    ar.update_attributes!(status: "accepted")
    ar.duty_stations << dt_sf
    ar.save!

    ar = SbaRoleAccessRequest.create!(roles_map: { "#{bu}".upcase => { "8a" => ["analyst"] } }, user_id: user.id)
    ar.update_attributes!(status: "accepted")
    ar.duty_stations << dt_pily
    ar.save!
  end
end

supervisor = %w(
  sba_supervisor_8a_cods
  sba_supervisor_8a_hq_program
  sba_supervisor_8a_hq_aa
  sba_supervisor_8a_size
  sba_supervisor_8a_ops
  sba_supervisor_8a_district_office
  sba_supervisor_8a_hq_ce
  sba_supervisor_8a_hq_legal
  sba_supervisor_8a_oig
  sba_director_8a_district_office
  sba_deputy_director_8a_district_office
)

supervisor.each do |name|
  splited = name.split("_8a_")
  bu = splited[1]

  Rails.logger.info "Create 8(a) Supervisor with duty stations"
  # 8A Sba Supervisor users
  (1..5).each do |i|
    Rails.logger.info i
    if Feature.active?(:idp)
      user = User.new(first_name: "sba_supervisor_#{i}", last_name: name.humanize, email: "#{name}_#{i}@mailinator.com", password: "Not@allthepassword1", confirmation_token: "eight-a-CgmvRKDtqr8349nxri3oeuSf4oAK8Y_#{name}_#{i}", confirmed_at: Time.now, max_id: "B12345678_#{name}_#{i}")
    else
      user = User.new(first_name: "sba_supervisor_#{i}", last_name: name.humanize, email: "#{name}_#{i}@mailinator.com", password: "Not@allthepassword1", password_confirmation: "Not@allthepassword1", confirmation_token: "eight-a-CgmvRKDtqr8349nxri3oeuSf4oAK8Y_#{name}_#{i}", confirmed_at: Time.now, max_id: "B12345678_#{name}_#{i}")
    end

    user.skip_confirmation!
    user.roles_map = { "#{bu}".upcase => { "8a" => ["supervisor"] } }
    user.duty_stations << dt
    user.duty_stations << dt_pily
    user.save!

    business_unit = BusinessUnit.find_by_name "#{bu}".upcase
    user.office_locations.create!(business_unit_id: business_unit.id)

    # Each Dutty Station needs to have only one AR this is because each request is sent to a separate supervisor.
    ar = SbaRoleAccessRequest.create!(roles_map: { "#{bu}".upcase => { "8a" => ["supervisor"] } }, user_id: user.id)
    ar.update_attributes!(status: "accepted")
    ar.duty_stations << dt
    ar.save!

    ar = SbaRoleAccessRequest.create!(roles_map: { "#{bu}".upcase => { "8a" => ["supervisor"] } }, user_id: user.id)
    ar.update_attributes!(status: "accepted")
    ar.duty_stations << dt_pily
    ar.save!
  end
end

Rails.logger.info "force duty station relationships so annual review assignment workflow is not empty"
# force duty station relationships so annual review assignment workflow is not empty
user1 = User.find_by(email: "sba_supervisor_8a_cods_1@mailinator.com")
user2 = User.find_by(email: "sba_supervisor_8a_district_office_1@mailinator.com")
user3 = User.find_by(email: "sba_supervisor_8a_district_office_2@mailinator.com")
user4 = User.find_by(email: "sba_analyst_8a_district_office_1@mailinator.com")
user5 = User.find_by(email: "sba_analyst_8a_district_office_2@mailinator.com")

DutyStation.all.each do |dt|
  user1.duty_stations << dt
  user2.duty_stations << dt
  user3.duty_stations << dt
  user4.duty_stations << dt
  user5.duty_stations << dt
end

user1.save!
user2.save!
user3.save!
user4.save!
user5.save!

Rails.logger.info "Setup test users for BDMIS Migration"
# Setup test users for BDMIS Migration
user = User.find_by(email: "sba_supervisor_8a_district_office_1@mailinator.com")
user.duty_stations << dt_pily
user.save!

user = User.find_by(email: "sba_supervisor_8a_district_office_2@mailinator.com")
user.duty_stations << dt_sf
user.save!

Rails.logger.info "set up users to test annual review reassignment"
# set up users to test annual review reassignment
dt_conn = DutyStation.find_by(name: "Connecticut")
dt_kc = DutyStation.find_by(name: "Kansas City")
user3 = User.find_by(email: "sba_supervisor_8a_district_office_3@mailinator.com")
user3.duty_stations << dt_conn
user3.duty_stations << dt_kc
user3.save!

%w(CODS DISTRICT_OFFICE HQ_LEGAL OIG HQ_PROGRAM HQ_AA SIZE OPS).each do |office|
  Rails.logger.info "Creating office location: #{office}"
  User.find_by(email: "sba_supervisor_8a_cods_2@mailinator.com").office_locations.create!(business_unit_id: BusinessUnit.find_by(name: office).id)
end

if Feature.active?(:elasticsearch)
  begin
    Rails.logger.info "Delete all CasesV2Index in ES"
    # Delete all indexes in ES
    #CasesIndex.delete!
    CasesV2Index.delete!
  rescue Exception => error
    Rails.logger.warn "Delete all CasesV2Index in ES Failed: #{error.message}"
  end
  Rails.logger.info "Recreate all CasesV2Index in ES"
  # Recreate all indexes in ES
  #CasesIndex.create!
  CasesV2Index.create!
  Rails.logger.info "Running CasesV2Index.import"
  # There should be nothing to import as we don't have an appication with a cert at this time.
  #CasesIndex.import
  CasesV2Index.import
end

Rails.logger.info "Make all seeded documents skip AV Scanner and Compression"
# Make all seeded documents skip AV Scanner and Compression
Document.update_all("av_status='OK', compressed_status='failed'")

# Seeding sample data for BDMIS Migration
#Questionnaire::EightAMigrated.load_from_csv!('db/fixtures/bdmis/initial_import')
#Questionnaire::EightAMigrated.load_from_csv!('db/fixtures/bdmis/sprint_2_import')

if Feature.active?(:elasticsearch)
  begin
    Rails.logger.info "Delete all AgencyRequirementsIndex in ES"
    # Delete all indexes in ES
    AgencyRequirementsIndex.delete!
  rescue Exception => error
    Rails.logger.warn "Delete all AgencyRequirementsIndex in ES Failed: #{error.message}"
  end
  Rails.logger.info "Recreate all AgencyRequirementsIndex in ES"
  # Recreate index in ES
  AgencyRequirementsIndex.create!
  # We do not import AgencyRequirementsIndex.import as the AgencyRequirement documents are added after this point (below).
end

# Seeding sample data for AgencyCo and AgencyRequirement.
# Currently Faker only works in dev :demo, :development, :qa, :training, :test
if %w(dev demo development qa training test).include? Rails.env
  Rails.logger.info "Seeding sample data for AgencyCo and AgencyRequirement."
  AgencyCo.create! first_name: Faker::Name.unique.first_name, last_name: Faker::Name.unique.last_name
  AgencyCo.create! first_name: Faker::Name.unique.first_name, last_name: Faker::Name.unique.last_name
  AgencyCo.create! first_name: Faker::Name.unique.first_name, last_name: Faker::Name.unique.last_name

  # Seeding sample data for AgencyRequirement. Most of the fields are associations with other models.
  100.times {
    agency_req = AgencyRequirement.create({ :user_id => User.last.id,
                                            :duty_station_id => DutyStation.order("RANDOM()").first.id,
                                            :agency_naics_code_id => AgencyNaicsCode.order("RANDOM()").first.id,
                                            :agency_office_id => AgencyOffice.order("RANDOM()").first.id,
                                            :agency_offer_code_id => AgencyOfferCode.order("RANDOM()").first.id,
                                            :agency_offer_scope_id => AgencyOfferScope.order("RANDOM()").first.id,
                                            :agency_offer_agreement_id => AgencyOfferAgreement.order("RANDOM()").first.id,
                                            :agency_contract_type_id => AgencyContractType.order("RANDOM()").first.id,
                                            :agency_co_id => AgencyCo.order("RANDOM()").first.id,
                                            :title => Faker::Company.unique.name + " " + Faker::Company.suffix,
                                            :unique_number => "#{("A".."Z").to_a[rand(26)]}#{("A".."Z").to_a[rand(26)]}#{Time.now.to_i}#{("A".."Z").to_a[rand(26)]}",
                                            :description => Faker::Twitter.status[:text],
                                            :received_on => Faker::Date.backward(4),
                                            :estimated_contract_value => 20000,
                                            :contract_value => 20000,
                                            :offer_solicitation_number => 211,
                                            :offer_value => Faker::Twitter.status[:text],
                                            :contract_number => Faker::Twitter.status[:text],
                                            :agency_comments => Faker::Twitter.status[:text],
                                            :contract_comments => Faker::Twitter.status[:text],
                                            :comments => Faker::Twitter.status[:text],
                                            :contract_awarded => [true, false].sample })
    AgencyRequirementOrganization.create(agency_requirement_id: agency_req.id, organization_id: Organization.all.first.id)
    AgencyRequirementOrganization.create(agency_requirement_id: agency_req.id, organization_id: Organization.all.last.id)
  }
end

if Feature.active?(:elasticsearch)
  Rails.logger.info "Running AgencyRequirementsIndex import"
  AgencyRequirementsIndex.import
end

Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |seed|
  load seed
end

Rails.logger.info "Finished db:seed!!!"



