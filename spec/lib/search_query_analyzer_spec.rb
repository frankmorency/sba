require 'rails_helper'
require Rails.root.join("lib/search_query_analyzer.rb")

RSpec.describe Search::SearchQueryAnalyzer do
  let(:subject) { Search::SearchQueryAnalyzer.new("") }

  describe "#search_query" do
    context "url without search terms" do
      let(:url) { "/sba_analyst/cases/mpp?mpp[case_owner]=&mpp[cs_active]=0" }

      it "returns blank" do
        expect(subject.search_query(url, "mpp[search]")).to eq([""])
      end
    end

    context "url with search terms" do
      let(:url) { "/sba_analyst/cases/mpp?utf8=_&mpp[search]=JORDON&mpp[ia_no_review]=0" }

      it "returns the search term" do
        expect(subject.search_query(url, "mpp[search]")).to eq(['JORDON'])
      end
    end
  end
end
