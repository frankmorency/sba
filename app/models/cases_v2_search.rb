

class CasesV2Search
  MAX_SEARCH_RESULTS = 20

  PATH_MAP = {
      program: 'certificates',
      sba_office: 'certificates',
      review_type: 'certificates.reviews',
      review_status: 'certificates.reviews',
      review_8a_annual_status: 'certificates.reviews',
      review_8a_initial_status: 'certificates.reviews',
      certificate_status: 'certificates',
      certificate_type: 'certificates',
      case_owner: 'certificates.reviews',
      current_reviewer: 'certificates.reviews',
      servicing_bos: 'certificates',
    }

    def search(query_term, offset, limit, options = {})
      res = CasesV2Index.
        offset(offset).
        limit(limit).
        query(query_filter(query_term)).
        query(program_filter(options)).
        query(sba_office_filter(options)).
        query(review_type_filter(options)).
        query(review_status_filter(options)).
        query(review_8a_status_filter(options)).
        query(no_review_filter(options)).
        query(certificate_status_filter(options)).
        query(certificate_type_filter(options)).
        query(case_owner_filter(options)).
        query(current_reviewer_filter(options)).
        query(servicing_bos_filter(options)).
        query(start_date_range_eight_a_filter(options))
      res = res.order(options[:order]) if options[:order]
      res
    end

    private

  def query_filter(query)
    return if query.blank?
    { multi_match: { query: query, fields: %w[firm_name duns firm_owner naics], type: 'phrase'} }
  end

  def start_date_range_eight_a_filter(options)

    return if options[:start_date_range_eight_a].nil?
    return if options[:start_date_range_eight_a][0].blank?


    start_date_str = options[:start_date_range_eight_a][0].gsub('/', '-')
    end_date_str = options[:start_date_range_eight_a][1].gsub('/', '-')
    start_year = start_date_str[6..9]
    start_day = start_date_str[3..4]
    start_month = start_date_str[0..1]
    start_date_str = start_year + '-' + start_month + '-' + start_day

    if !options[:start_date_range_eight_a][1].blank?
      end_year = end_date_str[6..9]
      end_day = end_date_str[3..4]
      end_month = end_date_str[0..1]
      end_date_str = end_year + '-' + end_month + '-' + end_day
      query_hash = {
        bool: {
          should: [
            {
              range:{
                certificate_start_date_eight_a:{
                  gte: start_date_str,
                  lte: end_date_str,
                  format: "yyyy-MM-dd"
                }
              }
            }
          ]
        }
      }
    else
      query_hash = {
        bool: {
          should: [
            {
              range:{
                certificate_start_date_eight_a:{
                  gte: start_date_str,
                  format: "yyyy-MM-dd"
                }
              }
            }
          ]
        }
      }
    end
    query_hash
  end


  def program_filter(options)
      extract_filter(options, :program, 'program')
  end

  def sba_office_filter(options)
    return unless options.dig(:sba_office)
    extract_filter(options, :sba_office, 'district_office')
  end

  def review_type_filter(options)
    return unless options.dig(:review_type)
    extract_filter(options, :review_type, 'type')
  end

  def review_status_filter(options)
    return unless options.dig(:review_status)
    extract_filter(options, :review_status, 'status')
  end


  def no_review_filter(options)
    return unless options.dig(:no_review)
    query_hash = {
      bool: {
        must: [
          {
            bool: {
              must: [
                {
                  nested: {
                    path: "certificates",
                    query: {
                      bool: {
                        must: [
                          {
                            bool: {
                              must: [
                                {
                                  match_phrase: {
                                    "certificates.program": "#{options[:program]}"
                                  }
                                }
                              ],
                              must_not: [
                                {
                                  nested: {
                                    path: "certificates.reviews",
                                    query: {
                                      bool: {
                                        must: [
                                          {
                                            exists: {
                                              field: "certificates.reviews.status"
                                            }
                                          }
                                        ]
                                      }
                                    }
                                  }
                                }
                              ]
                            }
                          }
                        ]
                      }
                    }
                  }
                }
              ]
            }
          }
        ]
      }
    }
    query_hash
  end

  def review_8a_status_filter(options)
    query_hash = {
      bool: {
        should: []
      }
    }
    query_hash_should = query_hash.dig(:bool, :should)
    if options[:review_8a_annual_status].present?
      query_hash_should.push(
        extract_filter(options, :review_8a_annual_status, 'status', 'EightAAnnualReview')
      )
    end
    if options[:review_8a_initial_status].present?
      query_hash_should.push(
        extract_filter(options, :review_8a_initial_status, 'status', 'EightAInitial')
      )
    end
    query_hash
  end

  def certificate_status_filter(options)
    return unless options.dig(:certificate_status)
    extract_filter(options, :certificate_status, 'status')
  end

  def certificate_type_filter(options)
    return unless options.dig(:certificate_type)
    extract_filter(options, :certificate_type, 'type')
  end

  def case_owner_filter(options)
    return unless options.dig(:case_owner)
    extract_filter(options, :case_owner, 'case_owner')
  end

    def current_reviewer_filter(options)
      return unless options.dig(:current_reviewer)
      extract_filter(options, :current_reviewer, 'current_reviewer')
    end

  def servicing_bos_filter(options)
    return unless options.dig(:servicing_bos)
    extract_filter(options, :servicing_bos, 'servicing_bos')
  end

  def extract_filter(hash, symbol, key, type = nil)
    value = hash[symbol]
    if value.present?
      # ES6.2: { match: { key => value } }
      if PATH_MAP[symbol].include?('certificates.reviews')
        generate_review_query(hash, symbol, key, value, type)
      else
        generate_certificate_query(symbol, key, value, type)
      end
    else
      { match_all: {} }
    end
  end

  def generate_review_query(hash, symbol, key, value, type)
    query_hash = {
      nested: {
        path: 'certificates',
        query: {
          nested: {
            path: 'certificates.reviews',
            query: {
              bool: {
                should: []
              }
            }
          }
        }
      }
    }
    query_hash_should = query_hash.dig(:nested, :query, :nested, :query, :bool, :should)
    add_filters_to_should(query_hash_should, symbol, key, value, type)
    query_hash
  end

  def generate_certificate_query(symbol, key, value, type)
    query_hash = {
      nested: {
        path: 'certificates',
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
    hash.push({match_phrase: { "#{PATH_MAP[symbol]}.#{key}": "#{value}" } })
  end
end
