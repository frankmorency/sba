require_relative '../../app/models/section/question_section'

namespace :versions do
  desc "Go back and reversion all the old stuff"
  task retrofit: :environment do
    SbaApplication.retrofit
  end
end
