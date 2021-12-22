namespace :app do
  namespace :fill do
    desc "Load all the answers for an application (set APP_ID env variable)"
    task eight_a: :environment do
      Loader::EightA.load ENV['APP_ID']
    end

    desc "Load all the answers for an application (set APP_ID env variable)"
    task eight_a_disadvantaged_individual: :environment do
      Loader::EightASubApp.load ENV['APP_ID']
    end

    desc "Load all the answers for an application (set APP_ID env variable)"
    task eight_a_annual: :environment do
      Loader::EightAAnnual.load ENV['APP_ID']    
    end
  end
end