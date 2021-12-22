require Rails.root.join("lib/search_query_analyzer.rb")

namespace :search do
  # USAGE: rake search:export_search_terms[google-analytics.csv]
  desc "Reads a CSV with URLs from google analytics and extracts the search terms."
  task :export_search_terms, [:csv_path] => [:environment] do |task, args|
    Rails.logger = Logger.new(STDOUT)
    Rails.logger.info "Starting rake search:export_search_terms[#{args[:csv_path]}]"

    if args[:csv_path].blank?
      Rails.logger.error "rake search:export_search_terms csv_path not supplied. Exiting"
    end

    search_query_analyzer = Search::SearchQueryAnalyzer.new(args[:csv_path])
    search_query_analyzer.run
    search_query_analyzer.export_csv
    Rails.logger.info "Finished rake search:export_search_terms[#{args[:csv_path]}]"
  end
end
