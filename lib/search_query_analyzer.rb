require 'cgi'
require 'csv'

# This call reads a CSV with URLs from google analytics and extracts the search terms.
module Search
  class SearchQueryAnalyzer

    def initialize(file_path)
      @file_path = file_path
      @headers = []
      @output_row = []
    end

    def run
      CSV.foreach(@file_path, headers: true) do |row|
        begin
          @headers = row.headers if @headers.blank?
          url = row[0]
          @output_row << row.to_hash.values + search_query(url, 'eight_a[search]') + search_query(url, 'mpp[search]') + search_query(url, 'wosb[search]')
        rescue Exception => e
          puts "Exception #{e.message}. Page URL #{row[0]}"
        end
      end
    end

    # parse the URL params. If search does not exist, returns empty array.
    def search_query(url, param)
      hash = CGI::parse(url)
      if (hash[param].present? && hash[param] != [""])
        hash[param]
      else
        [""]
      end
    end

    # Output CSVs in the Rails root directory
    def export_csv
      @headers = @headers + ["eight_a search query"] + ["mpp search query"] + ["wosb search query"]

      op_csv = "#{@file_path.split(".")[0]}_search_queries.csv"

      CSV.open(op_csv, "w") do |csv|
        csv << @headers
        @output_row.each do |query|
          csv << query
        end
      end

      puts "#{op_csv} output file written."
    end
  end
end

# sqa = Search::SearchQueryAnalyzer.new("/Users/sarlekar/Downloads/ga.csv")
# sqa.run
# sqa.export_csv
