require 'rails_helper'

# ignoring tests for now.  dependent on dump-sbaone_scrubbed_121117-201804301529.backup db restore
RSpec.describe CasesV2Search, type: :model do
  describe "#search" do
    xit 'should search by firm name' do
      results = CasesV2Search.new.search('INC', 0, 1)
      expect(results.size).to eq(1)
    end

    xit 'should search by dun' do
      results = CasesV2Search.new.search('079614479', 0, 1)
      expect(results.size).to eq(1)
    end

    xit 'should search by firm owner' do
      results = CasesV2Search.new.search('Dawson', 0, 1)
      expect(results.size).to eq(1)
    end

    xit 'should paginate' do
      results = CasesV2Search.new.search('INC', 0, 2)
      expect(results.size).to eq(2)
      results = CasesV2Search.new.search('INC', 2, 2)
      expect(results.size).to eq(2)
      results = CasesV2Search.new.search('INC', 4, 2)
      expect(results.size).to eq(2)
    end

    xit 'should give a total count' do
      results = CasesV2Search.new.search('INC', 0, 1)
      expect(results.total_count > 1000).to eq(true)
    end

    xit 'should filter on program' do
      results = CasesV2Search.new.search('INC', 0, 1, {program:'WOSB'})
      expect(results.size).to eq(1)
    end

    xit 'should filter on sba_office' do
      results = CasesV2Search.new.search('INC', 0, 1, {sba_office:'Philadelphia'})
      expect(results.size).to eq(1)
    end

    xit 'should filter on review_type' do
      results = CasesV2Search.new.search('INC', 0, 1, {review_type:'Review::EightAAnnualReview'})
      expect(results.size).to eq(1)
    end

    xit 'should filter on review_status' do
      results = CasesV2Search.new.search('INC', 0, 1, {review_status:'screening'})
      expect(results.size).to eq(1)
    end

    xit 'should allow multiple filters' do
      options = {
        program:'WOSB',
        sba_office:'Philadelphia',
        review_type:'Review::EightAAnnualReview',
        review_status:'screening'
      }
      results = CasesV2Search.new.search('INC', 0, 1, options)
      expect(results.size).to eq(1)
    end

    xit 'should filter the results and lower the hit count for the original query' do
      options = {
        program:'WOSB',
        sba_office:'Philadelphia',
        review_type:'Review::EightAAnnualReview',
        review_status:'screening'
      }
      results = CasesV2Search.new.search('INC', 0, 1, options)
      expect(results.total_count).to eq(1)
    end

    xit 'it should dynamically update the index when updating an organization' do
      duns = '139133230'
      results = CasesV2Search.new.search(duns, 0, 1)
      expect(results[0].attributes['firm_type']).to eq('s-corp')
      Organization.find_by(duns: duns).update_attribute(:firm_type, 'llc')
      results = CasesV2Search.new.search(duns, 0, 1)
      expect(results[0].attributes['firm_type']).to eq('llc')
      Organization.find_by(duns: duns).update_attribute(:firm_type, 's-corp')
    end

    xit 'should sort results by newest submit_date' do
      results = CasesV2Search.new.search(
        'INC', 0, 10, sort_criteria: {submit_date_newest: :desc})

      submit_dates = results.collect {|row| row.attributes['submit_date_newest']}
      expect(submit_dates).to eq(submit_dates.sort.reverse)
    end

    xit 'should sort results by oldest submit_date' do
      results = CasesV2Search.new.search(
        'INC', 0, 10, sort_criteria: {submit_date_eight_a: :asc})

      submit_dates = results.collect {|row| row.attributes['submit_date_eight_a']}
      expect(submit_dates).to eq(submit_dates.sort)
    end

    xit 'should sort results by newest next action due date' do
      results = CasesV2Search.new.search(
        'INC', 0, 10, sort_criteria: {submit_date_eight_a: :desc})

      submit_dates = results.collect {|row| row.attributes['submit_date_eight_a']}
      expect(submit_dates).to eq(submit_dates.sort.reverse)
    end

    xit 'should sort results by oldest next action due date' do
      results = CasesV2Search.new.search(
        'INC', 0, 10, sort_criteria: {next_action_due_date_oldest: :asc})

      submit_dates = results.collect {|row| row.attributes['next_action_due_date_oldest']}
      expect(submit_dates).to eq(submit_dates.sort)
    end
  end
end

# CasesV2Search
# #search
# should search by firm name
# should search by dun
# should search by firm owner
# should paginate
# should give a total count
# should filter on program
# should filter on sba_office
# should filter on review_type
# should filter on review_status
# should allow multiple filters
# should filter the results and lower the hit count for the original query
#
# Finished in 0.21371 seconds (files took 12.71 seconds to load)
# 11 examples, 0 failures

# curl "http://localhost:9200curl "http://localhost:9200/_cat/indices?v"

# health status index                  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
# yellow open   cases                  S7LoyWaVSAKRV93WNXPuDw   5   1          0            0      1.2kb          1.2kb
# yellow open   cases_v2_1525656517643 gWmIXKtDSZGbSGLx_4E30A   5   1      21106            0     10.7mb         10.7mb
# yellow open   test_cases             4kIzwHa_TcOsdMIJonZHdw   5   1          0            0      1.2kb          1.2kb
