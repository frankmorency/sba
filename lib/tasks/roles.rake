namespace :roles do
  desc "Set the Roles for users  Gov users: roles:verify_validity[true] for NON gov users roles:verify_validity[false]"
  task :verify_validity, [:max_only] =>[ :environment ] do |t, args|
    users = []
    if args[:max_only] == 'true'
      users = User.where('max_id IS NOT NULL')
      puts "gov users"
    else
      users = User.where('max_id IS NULL')
      puts "NON gov users"
    end

    users.all.each do |u|
      SbaOrganizationMapping.set_roles_map(u)
    end
  end
end