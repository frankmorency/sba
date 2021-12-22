module EightAInitialSbaAnalyst
  class DashboardController < EightAInitialSbaAnalystController
    include SbaWorkload

    before_action :set_current_page

    def index
      @workload = current_user.workload

      if params[:submit_search] # someone searches
        set_search_variable
        set_filter_variables_during_search
      elsif params[:submit_filter] # someone filters
        set_filter_variables
      else
        set_default_search_variable
        set_filter_variables_during_search
      end
      set_sort_options
      perform_search(set_sort_order)
    end

    private

    def set_current_page
      @current_page = params[:page] || 1
    end

    def set_default_search_variable
      @search = ''
    end

    def set_filter_variables_during_search
      @sba_office = ''
      @agency = ''
      @contract_type = ''
      @code = ''
      @contract_awarded = false
    end

    def set_filter_variables
      @search = params[:requirement].blank? ? '' : params[:requirement][:search]
      @sba_office = (params[:requirement].blank? || params[:requirement][:sba_office] == "All offices") ? '' : params[:requirement][:sba_office]
      @agency = params[:requirement].blank? ?  '' : params[:requirement][:agency]
      @contract_type = params[:requirement].blank? ?  '' : params[:requirement][:contract_type]
      @code = params[:requirement].blank? ? '' : params[:requirement][:code]
      @contract_awarded = params[:requirement].blank? ? false : params[:requirement][:contract_status]
    end

    def set_sort_options
      @sort_options = [['Relevance',:relevance], ['Next action due: Earliest',:next_action_due_earliest], ['Next action due: Latest',:next_action_due_latest], ['Firm name: Ascending',:firm_name_ascending],['Firm name: Descending',:firm_name_descending], ['Oldest',:oldest], ['Newest',:newest]]
    end

    def set_sort_order
      sort_order = ['next_action_due_earliest', {'next_action_due_date': :asc}]
      case params[:sort]
        when 'relevance' || '' || nil
          sort_order = ['relevance', nil]
        when 'next_action_due_earliest'
          sort_order = ['next_action_due_earliest', {'next_action_due_date': :asc}]
        when 'next_action_due_latest'
          sort_order = ['next_action_due_latest', {'next_action_due_date': :desc}]
        when 'firm_name_ascending'
          sort_order = ['firm_name_ascending', {firm_name_sort: :asc}]
        when 'firm_name_descending'
          sort_order = ['firm_name_descending', {firm_name_sort: :desc}]
        when 'oldest'
          sort_order = ['oldest', {'submit_date_eight_a': :asc}]
        when 'newest'
          sort_order = ['newest', {'submit_date_eight_a': :desc}]
      end
      sort_order
    end

    def perform_search(sort_order)
      @sort_order = sort_order[0]
      @cases = CasesV2Search.new.search('', @current_page, 9999).order(sort_order[1]).paginate(page: @current_page, per_page: 9999)
    end

  end
end
