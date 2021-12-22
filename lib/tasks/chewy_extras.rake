require 'chewy/rake_helper'

namespace :chewy do
  desc "updates cases#index"
  task update_cases_index: :environment do
    Chewy::RakeHelper.update_index('cases_v2_index')
  end

  desc "updates agency_requirements_index"
  task update_agency_requirements_index: :environment do
    Chewy::RakeHelper.update_index('agency_requirements_index')
  end
end