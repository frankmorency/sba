require 'will_paginate/array'
module SbaAnalyst
  class AgencyRequirementsSearchController < SbaAnalystController
    before_action :set_current_page, only: [:index]

    def index
      session.delete(:download_ids)
      set_search_variable
      set_filter_variables
      perform_search
      set_pills
      create_sort_options
    end

    def search
      session.delete(:download_ids)
      @current_page = 1
      set_search_variable
      set_filter_variables
      perform_search
      @pagination_display = get_pagination_number(@current_page, @agency_reqs.total, AgencyRequirementsSearch::MAX_SEARCH_RESULTS)
      respond_to do |format|
        format.js { render layout: false }
        format.xml { render xml: @agency_reqs }
      end
    end

    def download
      respond_to do |format|
        format.csv {send_data AgencyRequirementCSV.search_csv(session[:download_ids]), filename: "all_requirements_search_export.csv"}
      end
    end

    private

    def set_pills
      @pills = params[:requirement]&.delete_if { |k, v| v.blank? || v == "All offices" || k == "search"}
    end

    def set_current_page
      @current_page = params[:page] || 1
    end

    def set_default_search_variable
      @search = ''
    end

    def set_search_variable
      @search = params[:requirement].blank? ? '' : params[:requirement][:search]
    end

    def set_filter_variables_during_search
      @sba_office = ''
      @agency = ''
      @contract_type = ''
      @code = ''
      @contract_awarded = ''
    end

    def set_filter_variables
      @search = params[:requirement].blank? ? '' : params[:requirement][:search]
      @sba_office = (params[:requirement].blank? || params[:requirement][:sba_office] == "All offices") ? '' : params[:requirement][:sba_office]
      @agency = params[:requirement].blank? ?  '' : params[:requirement][:agency]
      @contract_type = params[:requirement].blank? ?  '' : params[:requirement][:contract_type]
      @code = params[:requirement].blank? ? '' : params[:requirement][:code]
      @contract_awarded = params[:requirement].blank? ? '' : params[:requirement][:contract_status]
      @sort = params[:requirement].blank? ? '' : params[:requirement][:sort]
    end

    def perform_search
      @agency_reqs = AgencyRequirementsSearch.new.search(@search, @current_page, AgencyRequirementsSearch::MAX_SEARCH_RESULTS, {
          duty_station: @sba_office,
          agency_office: @agency,
          agency_contract_type: @contract_type,
          agency_offer_code: @code,
          agency_contract_awarded: @contract_awarded
      }).order(get_sort_order).paginate(page: @current_page, per_page: AgencyRequirementsSearch::MAX_SEARCH_RESULTS)
      #@all_reqs = AgencyRequirementsSearch.new.search(@search, @current_page, @agency_reqs.total, {
      #    duty_station: @sba_office,
      #    agency_office: @agency,
      #    agency_contract_type: @contract_type,
      #    agency_offer_code: @code,
      #    agency_contract_awarded: @contract_awarded
      #})
      session[:download_ids] = @agency_reqs.collect(&:id).map(&:to_i)
    end

    def get_sort_order
      return nil if params["requirement"].nil?
      return {sort_created_at: :asc} if params["requirement"]["sort"] == 'Ascending: Date'
      return {sort_created_at: :desc} if params["requirement"]["sort"] == 'Descending: Date'
    end

    def create_sort_options
      @sort_options = [
        {name: "Relevance", value: ''},
        { name: "Ascending: Date", value: "Ascending: Date"},
        { name: "Descending: Date", value: "Descending: Date" }
      ]
    end

  end
end
