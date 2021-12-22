# noglob curl -X GET localhost:9200/cases/_search?q=duns:"111292429"
# noglob curl -X GET localhost:9200/cases/_search?q="111292429"
# This is the curl that match
# curl -X GET 'http://localhost:9200/_search?pretty' -d '{"query":{"bool":{"must":[{"multi_match":{"query":"8(a)","operator":"or","fields":["business_name", "business_id", "duns", "program", "review_type", "review_type_humanized", "submitted_date", "owner", "reviewer",  "status", "status_humanize", "program_title", "determination", "determination_humanized", "recommendation", "recommendation_humanized"]}}],"filter":[ {"range":{"date_submitted":{"gte":"4/1/2017", "lte":"4/31/2017", "format":"MM/dd/yyyy"}}}]}}}'
# curl -X GET 'http://escluster.qa.sba-one.net:9200/_search?pretty' -d '{"query":{"bool":{"must":[{"multi_match":{"query":"WOSB, EDWOSB","operator":"or","fields":["business_name", "business_id", "duns", "program", "review_type", "review_type_humanized", "submitted_date", "owner", "reviewer",  "status", "status_humanize", "program_title", "determination", "determination_humanized", "recommendation", "recommendation_humanized"]}}]}}}'

require 'elasticsearch'
require 'elasticsearch/dsl'
include Elasticsearch::DSL

class CasesSearch

  def self.filter_by(search_param, options)
    filter_param = {}
    filter_param = options[:filter] unless options[:filter].nil?
    from = 0
    from = options[:from] unless options[:from].nil?
    size = Settings.elasticsearch.pagination_size
    size = options[:size] unless options[:size].nil?
    direction = "desc"
    direction = options[:direction] unless options[:direction].nil?
    column = "date_submitted"
    column = options[:column] = "date_submitted" unless options[:column].nil?

    client = Elasticsearch::Client.new host: "#{Settings.elasticsearch.url}"

    definition = search do
      query do
        bool do
          must do
            multi_match do
              query search_param
              operator 'or'
              fields ["business_name", "business_id", "duns", "program", "review_type", "review_type_humanized", "submitted_date", "owner", "reviewer",  "status", "status_humanize", "program_title", "determination", "determination_humanized", "recommendation", "recommendation_humanized"]
            end
          end
          filter do
          end
        end
      end
    end

    definition = definition.to_hash

    if search_param == "*" || (search_param =~ Regexp.new("^\s+$")) == 0 || search_param == ""
      definition[:query][:bool][:must][0] = {wildcard: {_all: '*'} }
    end

    if column == "date_submitted"
      definition[:sort] = [ { column => {:order => direction} } ]
      # I might be ok and not need to specify the type here
      # elsif  column == "reviewer" || column == "owner"
      #   definition[:sort] = [ { column => {"unmapped_type" : "long"} } ]
    elsif column == "determination" || column == "determination_humanized" || column == "recommendation" || column == "recommendation_humanized"
      # we don't want to sort the last column at this time since it is a mix of 2 columns
      definition[:sort] = nil
    else
      definition[:sort] = [ column => {"missing" => "_last"} ]
    end

    definition[:from] = from * Settings.elasticsearch.pagination_size
    definition[:size] = size

    final_hash = extract_and_apply_hash_filter(definition.to_hash, filter_param)  
    Rails.logger.warn("=====\n JSON TO ES SEARCH \n #{final_hash.to_json} \n=====\n")
    search_result = client.search index: "#{Settings.elasticsearch_index}", body: final_hash.to_json

    results = CasesSearch.prepare_display_for_pagination(search_result, from , size)
    return results
  end

  private

  def self.prepare_display_for_pagination(search_result, from=0 , size=Settings.elasticsearch.pagination_size )
    append = false
    cases = []
    times = []

    if search_result["hits"]["total"] > 0

      total_results = search_result["hits"]["total"]

      #  Create an array of nil values the size of resuts
      total_results.times do |i|
        cases << nil
      end

      remaing_results = total_results - (from * size)

      if remaing_results > Settings.elasticsearch.pagination_size
        times = Settings.elasticsearch.pagination_size
      else
        times = remaing_results
      end

      times.times do |i|
        cases[i+(from*size)] = search_result["hits"]["hits"][i]["_source"]
      end

    end

    return cases
  end

  def self.extract_and_apply_hash_filter(main_hash, filter_hash)
    filter_hash.each_pair do |key, value|
      filter = Hash.new()

      if key.to_s == 'submitted_date'
        unless( filter_hash['submitted_date']["from_month"].empty? || filter_hash['submitted_date']["from_day"].empty? || filter_hash['submitted_date']["from_year"].empty? ||
            filter_hash['submitted_date']["to_month"].empty? || filter_hash['submitted_date']["to_day"].empty? || filter_hash['submitted_date']["to_year"].empty? )

          start_date = "#{filter_hash['submitted_date']["from_month"]}/#{filter_hash['submitted_date']["from_day"]}/#{filter_hash['submitted_date']["from_year"]}"
          end_date = "#{filter_hash['submitted_date']["to_month"]}/#{filter_hash['submitted_date']["to_day"]}/#{filter_hash['submitted_date']["to_year"]}"

          filter[:range] = { date_submitted: { gte: start_date, lte: end_date, format: "MM/dd/yyyy"} }
        end
      else
        filter[:match] = { "#{key}": "#{value}"}
      end
      main_hash[:query][:bool][:filter] << filter
    end

    return main_hash
  end

end
