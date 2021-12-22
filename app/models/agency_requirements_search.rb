class AgencyRequirementsSearch
  MAX_SEARCH_RESULTS = 20

  # Sample queries
  # AgencyRequirementsSearch.new.search("131907411", 0, 10, {"duty_station":"Seattle"})
  # The options hash keys are: duty_station, agency_office, agency_offer_code, agency_contract_type
  # query_term will match for the search term in title, agency_office_name, duns and naics.
  def search(query_term, offset, limit, options = {})
    result = AgencyRequirementsIndex.
        offset(offset).
        limit(limit).
        query(query_filter(query_term)).
        query(duty_station_filter(options)).
        query(agency_office_filter(options)).
        query(agency_offer_code_filter(options)).
        query(agency_contract_type_filter(options)).
        query(agency_contract_awarded_filter(options))
    result = result.order(options[:order]) if options[:order]
    result
  end

  private
  def query_filter(query)
    return if query.blank?
    { multi_match: { query: query, fields: %w[title duns naics unique_number], type: 'phrase'} }
  end

  def duty_station_filter(options)
    extract_filter(options, :duty_station, 'name')
  end

  def agency_office_filter(options)
    extract_filter(options, :agency_office, 'name')
  end

  def agency_offer_code_filter(options)
    extract_filter(options, :agency_offer_code, 'name')
  end

  def agency_contract_type_filter(options)
    extract_filter(options, :agency_contract_type, 'name')
  end

  def agency_contract_awarded_filter(options)
    if options[:agency_contract_awarded].present?
      {match: {"contract_awarded": options[:agency_contract_awarded]}}
    else
      { match_all: {} }
    end
  end

  def extract_filter(hash, symbol, key, type = nil)
    value = hash[symbol]
    if value.present?
      # ES6.2: { match: { key => value } }
      generate_query(symbol, key, value, type)
    else
      { match_all: {} }
    end
  end

  def generate_query(symbol, key, value, type)
    query_hash = {
        nested: {
            path: "#{symbol}",
            query: {
                bool: {
                    should: []
                }
            }
        }
    }
    query_hash_should = query_hash.dig(:nested, :query, :bool, :should)
    add_filters_to_should(query_hash_should, symbol, key, value, type)
    query_hash
  end

  def add_filters_to_should(query_hash_should, symbol, key, value, type)
    if value.kind_of?(Array)
      value.each do |v|
        append_must_filter(query_hash_should, symbol, key, v, type)
      end
    else
      append_must_filter(query_hash_should, symbol, key, value, type)
    end
  end

  def append_must_filter(query_hash_should, symbol, key, value, type)
    return if query_hash_should.nil?
    query_hash_should.push(
        {
            bool: {
                must: []
            }
        }
    )
    query_hash_should_must = query_hash_should.last.dig(:bool, :must)
    append_match_filter(query_hash_should_must, symbol, key, value)
    append_match_filter(query_hash_should_must, symbol, 'type', type) if type
  end

  def append_match_filter(hash, symbol, key, value)
    hash.push({match_phrase: { "#{symbol}.#{key}": "#{value}" } })
  end

  def self.default_search_params
    {'requirement[search]': '', 'requirement[sba_office]': 'All offices', 'requirement[agency]': '', 'requirement[contract_type]': '', 'requirement[contract_awarded]': 'false', 'requirement[code]': '', 'requirement[sort]': ''}
  end
end
