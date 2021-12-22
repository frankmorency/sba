require 'rails_helper'
require 'rake'

load File.expand_path("../../../../lib/tasks/exporter/dsbs.rake", __FILE__)

describe "dsbs:exporter" do
    ActionMailer::Base.deliveries = [] # resets email deliveries
    Rake::Task.define_task(:environment)
    # Invoking the task causes agency_requirements_search_spec to throw a "Versions table not found" error
    # most likely related to the papertrail gem. 
    # TODO: complete the testing once the papertrail issue is resolved. 
    # Rake::Task["exporter:dsbs"].invoke
end
