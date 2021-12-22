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
  user.roles_map = { "Legacy" => { "SUPPORT" => ["admin"] } }
  user.save!
end
