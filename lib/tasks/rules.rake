namespace :rules do
  desc "Generate skip rules"
  task generate: :environment do
    SectionRule.update_skip_info!
  end

end
