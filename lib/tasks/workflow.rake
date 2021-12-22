namespace :workflow do
  desc "Generate a workflow graph for a model passed e.g. as 'MODEL=Order'."
  task :doc => :environment do

    klass = ENV['MODEL'].constantize

    Admin::WorkflowDiagram.generate! klass
  end
end