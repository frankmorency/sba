require 'will_paginate/array'
module SbaAnalyst
  class CasesController < SbaAnalystController
    include CasesHelper
    before_action :create_sort_options,  only: [:eight_a, :mpp, :wosb]

    MAX_SEARCH_RESULTS = 20

    def declined
      current_page = (params[:page] || 1)
      cases = (current_user.role_to_type_name == "mpp") ? Certificate::Mpp.declined : Certificate.where(id: 0)
      @cases = cases.paginate(:page => current_page.to_i, :per_page => 20)
    end

    def returned
      current_page = (params[:page] || 1)
      cases = (current_user.role_to_type_name == "mpp") ? Certificate::Mpp.returned_to_vendor : Certificate.where(id: 0)
      @cases = cases.paginate(:page => current_page.to_i, :per_page => 20)
    end

    # we redirect so users have url with query string that they can bookmark
    def index
      case current_user.role_to_type_name
      when 'eight_a'
        redirect_to eight_a_role_path
      when 'mpp'
        redirect_to mpp_role_path
      when 'wosb', 'edwosb', ['wosb','edwosb']
        redirect_to wosb_role_path
      when 'vs'
        redirect_to vs_role_path
      else
        redirect_to eight_a_role_path
      end
    end

    def download
      respond_to do |format|
        format.csv {send_data CasesCSV.search_csv(session[:download_ids], session[:program]), filename: "cases_search_export.csv"}
      end
    end

    def get_download_ids
      session[:download_ids] = @cases.collect(&:id).map(&:to_i)
    end  

    def eight_a
      session.delete(:download_ids)
      session.delete(:program)
      @program = "EIGHT_A"
      fparams = params["eight_a"]
      ar_filters = EightACaseSearch::AR_FILTERS
      ia_filters = EightACaseSearch::IA_FILTERS
      cs_filters = EightACaseSearch::CS_FILTERS
      @current_page = params[:page] || 1
      @breadcrumb_pills = []
      if fparams.nil?
        @eight_a = EightACaseSearch.new
        @cases = CasesV2Search.new.search('', @current_page, MAX_SEARCH_RESULTS, {program: 'EIGHT_A'}).paginate(page: @current_page, per_page: MAX_SEARCH_RESULTS)
        get_download_ids
        session[:program] = @program
      else
        breadcrumb_pills = fparams.reject {|k, v| v == "0" || v.blank? }
        breadcrumb_pills.each do |k, v|
          if k == "search"
            next if v.blank?
          elsif k == "start_date"
            @breadcrumb_pills.push({id: k, label: "Date", value: 'start date'})
          elsif k == "sba_office"
            next if v == "All offices"
            @breadcrumb_pills.push({id: "eight_a_"+k, label: "SBA Office", value: v})
          elsif k == "case_owner"
            next if v.blank?
            @breadcrumb_pills.push({id: "eight_a_"+k, label: "Case Owner", value: v})
          elsif k == "service_bos"
            next if v.blank?
            @breadcrumb_pills.push({id: "eight_a_"+k, label: "BOS", value: v})
          elsif v == "ar_early_graduation_recommended" || v == "ar_termination_recommended" || v == "ar_voluntary_withdrawal_recommended"
            v = v[3..-1]
            v = v.gsub('_', ' ')
            @breadcrumb_pills.push({id: "eight_a_"+k, label: "Adverse Action", value: v})
          elsif k[0..1] == "ar"
            v = v[3..-1]
            v = v.gsub('_', ' ')
            @breadcrumb_pills.push({id: "eight_a_"+k, label: "Annual Review", value: v})
          elsif k[0..1] == "ia"
            v = v[3..-1]
            v = v.gsub('_', ' ')
            @breadcrumb_pills.push({id: "eight_a_"+k, label: "Inital Application", value: v})
          elsif k[0..1] == "cs"
            v = v[3..-1]
            v = v.gsub('_', ' ')
            @breadcrumb_pills.push({id: "eight_a_"+k, label: "Certificate Status", value: v})
          end
        end
        ar_click = fparams.map {|x| ar_filters.include?(x[1]&.to_sym) }
        @ar_click = ar_click.include?(true)
        ia_click = fparams.map {|x| ia_filters.include?(x[1]&.to_sym) }
        @ia_click = ia_click.include?(true)
        @eight_a = EightACaseSearch.new(
          ar_screening: fparams["ar_screening"],
          ar_returned_with_deficiency_letter: fparams["ar_returned_with_deficiency_letter"],
          ar_processing: fparams["ar_processing"],
          ar_retained: fparams["ar_retained"],
          ar_early_graduation_recommended: fparams["ar_early_graduation_recommended"],
          ar_termination_recommended: fparams["ar_termination_recommended"],
          ar_voluntary_withdrawal_recommended: fparams["ar_voluntary_withdrawal_recommended"],
          ia_appeal_intent: fparams["ia_appeal_intent"],
          ia_screening: fparams["ia_screening"],
          ia_returned_with_15_day_letter: fparams["ia_returned_with_15_day_letter"],
          ia_closed: fparams["ia_closed"],
          ia_processing: fparams["ia_processing"],
          ia_sba_declined: fparams["ia_sba_declined"],
          ia_pending_reconsideration: fparams["ia_pending_reconsideration"],
          ia_pending_reconsideration_or_appeal: fparams["ia_pending_reconsideration_or_appeal"],
          ia_reconsideration: fparams["ia_reconsideration"],
          ia_appeal: fparams["ia_appeal"],
          ia_sba_approved: fparams["ia_sba_approved"],
          cs_pending: fparams["cs_pending"],
          cs_ineligible: fparams["cs_ineligible"],
          cs_active: fparams["cs_active"],
          cs_graduated: fparams["cs_graduated"],
          cs_early_graduated: fparams["cs_early_graduated"],
          cs_terminated: fparams["cs_terminated"],
          cs_withdrawn: fparams["cs_withdrawn"],
          cs_expired: fparams["cs_expired"],
          cs_bdmis_rejected: fparams["cs_bdmis_rejected"],
          case_owner: fparams["case_owner"],
          service_bos: fparams["service_bos"],
          sba_office: fparams["sba_office"],
          search: fparams["search"],
          sort: fparams["sort"],
          start_date: fparams["start_date"],
          end_date: fparams["end_date"]
        )
        @cases = get_eight_a_cases(fparams)

      end
      @pagination_display = get_pagination_number(@current_page, @cases.total, MAX_SEARCH_RESULTS)
      respond_to do |format|
        format.html
        format.js
        format.xml { render :xml => @cases }
      end
    end

    def mpp
      session.delete(:download_ids)
      session.delete(:program)
      @program = "MPP"
      fparams = params["mpp"]
      @breadcrumb_pills = []
      ia_filters = MppCaseSearch::IA_FILTERS
      cs_filters = MppCaseSearch::CS_FILTERS
      @current_page = params[:page] || 1
      @cases = []
      if fparams.nil?
        @mpp = MppCaseSearch.new
        @cases = CasesV2Search.new.search('', @current_page, MAX_SEARCH_RESULTS, {program: 'MPP'}).paginate(page: @current_page, per_page: MAX_SEARCH_RESULTS)
        #@all_cases = CasesV2Search.new.search('', 0, @cases.total, {program: 'MPP'})
        session[:download_ids] = @cases.collect(&:id).map(&:to_i)
        session[:program] = @program
      else
        breadcrumb_pills = fparams.reject {|k, v| v == "0" || v.blank? }
        breadcrumb_pills.each do |k, v|
          if k == "search"
            next if v.blank?
          elsif k == "case_owner"
            next if v.blank?
            @breadcrumb_pills.push({id: "mpp_"+k, label: "Case Owner", value: v})
          elsif k[0..1] == "ia"
            v = v[3..-1]
            v = v.gsub('_', ' ')
            @breadcrumb_pills.push({id: "mpp_"+k, label: "Inital Application", value: v})
          elsif k[0..1] == "cs"
            v = v[3..-1]
            v = v.gsub('_', ' ')
            @breadcrumb_pills.push({id: "mpp_"+k, label: "Certificate Status", value: v})
          end
        end
        ia_click = fparams.map {|x| ia_filters.include?(x[1]&.to_sym) }
        @ia_click = ia_click.include?(true)
        @mpp = MppCaseSearch.new(
          ia_assigned_in_progress: fparams["ia_assigned_in_progress"], ia_returned_for_modification: fparams["ia_returned_for_modification"], ia_recommend_eligible: fparams["ia_recommend_eligible"], ia_recommend_ineligible: fparams["ia_recommend_ineligible"], ia_determination_made: fparams["ia_determination_made"],
          cs_pending: fparams["cs_pending"], cs_ineligible: fparams["cs_ineligible"], cs_active: fparams["cs_active"], cs_graduated: fparams["cs_graduated"], cs_early_graduated: fparams["cs_early_graduated"], cs_terminated: fparams["cs_terminated"], cs_withdrawn: fparams["cs_withdrawn"], cs_expired: fparams["cs_expired"],
          ia_no_review: fparams["ia_no_review"],
          case_owner: fparams["case_owner"], search: fparams["search"], sort: fparams["sort"]
        )
        @cases = get_mpp_cases(fparams)
      end
      @pagination_display = get_pagination_number(@current_page, @cases.total, MAX_SEARCH_RESULTS)
      respond_to do |format|
        format.html
        format.js
        format.xml { render :xml => @cases }
      end
    end

    def wosb
      session.delete(:download_ids)
      session.delete(:program)
      @program = "WOSB"
      fparams = params["wosb"]
      @breadcrumb_pills = []
      ia_filters = WosbCaseSearch::IA_FILTERS
      cs_filters = WosbCaseSearch::CS_FILTERS
      as_filters = WosbCaseSearch::AS_FILTERS
      @current_page = params[:page] || 1
      if fparams.nil?
        @wosb = WosbCaseSearch.new
        @cases = CasesV2Search.new.search('', @current_page, MAX_SEARCH_RESULTS, {program: ['EDWOSB', 'WOSB']}).paginate(page: @current_page, per_page: MAX_SEARCH_RESULTS)
        #@all_cases = CasesV2Search.new.search('', 0, @cases.total, {program: ['EDWOSB', 'WOSB']})
        session[:download_ids] = @cases.collect(&:id).map(&:to_i)
        session[:program] = @program
      else
        breadcrumb_pills = fparams.reject {|k, v| v == "0" || v.blank? }
        breadcrumb_pills.each do |k, v|
          if k == "search"
            next if v.blank?
          elsif k == "case_owner"
            next if v.blank?
            @breadcrumb_pills.push({id: "wosb_"+k, label: "Case Owner", value: v})
          elsif k == "edwosb"
            @breadcrumb_pills.push({id: "wosb_"+k, label: "", value: v})
          elsif k == "wosb"
            @breadcrumb_pills.push({id: "wosb_"+k, label: "", value: v})
          elsif k[0..1] == "ia"
            v = v[3..-1]
            v = v.gsub('_', ' ')
            @breadcrumb_pills.push({id: "wosb_"+k, label: "Inital Application", value: v})
          elsif k[0..1] == "cs"
            v = v[3..-1]
            v = v.gsub('_', ' ')
            @breadcrumb_pills.push({id: "wosb_"+k, label: "Certificate Status", value: v})
          elsif k[0..1] == "as"
            v = v[3..-1]
            v = v.gsub('_', ' ')
            @breadcrumb_pills.push({id: "wosb_"+k, label: "Application Status", value: v})
          end
        end
        as_click = fparams.map {|x| as_filters.include?(x[1]&.to_sym) }
        @as_click = as_click.include?(true)
        @wosb = WosbCaseSearch.new(edwosb: fparams["edwosb"], wosb: fparams["wosb"],
          ia_assigned_in_progress: fparams["ia_assigned_in_progress"], ia_returned_for_modification: fparams["ia_returned_for_modification"], ia_recommend_eligible: fparams["ia_recommend_eligible"], ia_recommend_ineligible: fparams["ia_recommend_ineligible"], ia_determination_made: fparams["ia_determination_made"],
          case_owner: fparams["case_owner"], current_reviewer: fparams["current_reviewer"],
          cs_ineligible: fparams["cs_ineligible"], cs_active: fparams["cs_active"], cs_expired: fparams["cs_expired"],
          as_sba_approved: fparams["as_sba_approved"], as_third_party_certified: fparams["as_third_party_certified"], as_self_certified: fparams["as_self_certified"],
          ia_no_review: fparams["ia_no_review"],
        search: fparams["search"], sort: fparams["sort"] )
        @cases = get_wosb_cases(fparams)
      end
      @pagination_display = get_pagination_number(@current_page, @cases.total, MAX_SEARCH_RESULTS)
      respond_to do |format|
        format.html
        format.js
        format.xml { render :xml => @cases }
      end
    end

    def voluntary_suspension
      @voluntary_suspensions = VoluntarySuspension.send(params[:status]||:submitted)
    end

    def all_cases_search
      session.delete(:download_ids)
      session.delete(:program)
      @current_page = 1
      if params.dig(:eight_a)
        @program = "EIGHT_A"
        @cases = get_eight_a_cases(params["eight_a"])
      elsif params.dig(:mpp)
        @program = "MPP"
        @cases = get_mpp_cases(params["mpp"])
      elsif params.dig(:wosb)
        @program = "WOSB"
        @cases = get_wosb_cases(params["wosb"])
      end
      @pagination_display = get_pagination_number(@current_page, @cases.total, MAX_SEARCH_RESULTS)
      respond_to do |format|
        format.js { render layout: false }
        format.xml { render :xml => @cases }
      end
    end

    def sort_column
      Certificate.sort_column(params[:sort])
    end

    private

    def get_pagination_number(page_number, total, max_search_results)
      if total > max_search_results
        end_number = page_number.to_i * max_search_results
        start_number =  end_number - max_search_results
        start_number += 1
        start_number.to_s + "-" +  end_number.to_s + " of " + total.to_s + " results"
      else
        total.to_s + " results"
      end
    end

    def get_eight_a_cases(fparams)
      review_type = []
      ar_statuses = status_selected(EightACaseSearch::AR_FILTERS, fparams, 'ar_')
      review_type.push('EightAAnnualReview') if ar_statuses.length > 0
      ia_statuses = status_selected(EightACaseSearch::IA_FILTERS, fparams, 'ia_')
      review_type.push('EightAInitial') if ia_statuses.length > 0
      cs_statuses = status_selected(EightACaseSearch::CS_FILTERS, fparams, 'cs_')
      sba_office = fparams["sba_office"]
      sba_office = '' if fparams["sba_office"] == "All offices"
      cases = CasesV2Search.new.search(fparams["search"], @current_page, MAX_SEARCH_RESULTS,
        { program: 'EIGHT_A',
          sba_office: sba_office,
          review_type: review_type,
          review_8a_annual_status: ar_statuses,
          review_8a_initial_status: ia_statuses,
          certificate_status: cs_statuses,
          case_owner: fparams["case_owner"],
          servicing_bos: fparams["service_bos"],
          start_date_range_eight_a: [fparams["start_date"], fparams["end_date"]]
        }).order(get_sort_order(fparams, 'EIGHT_A')).paginate(page: @current_page, per_page: MAX_SEARCH_RESULTS)
        #@all_cases = CasesV2Search.new.search(fparams["search"], 0, cases.total,
        #                         { program: 'EIGHT_A',
        #                           sba_office: sba_office,
        #                           review_type: review_type,
        #                           review_8a_annual_status: ar_statuses,
        #                           review_8a_initial_status: ia_statuses,
        #                           certificate_status: cs_statuses,
        #                           case_owner: fparams["case_owner"],
        #                           servicing_bos: fparams["service_bos"]
        #                         })
        session[:download_ids] = cases.collect(&:id).map(&:to_i)
        session[:program] = @program
        cases
      end

      def get_mpp_cases(fparams)
        no_review = false
        review_type = []
        ia_statuses = status_selected(MppCaseSearch::IA_FILTERS, fparams, 'ia_')
        review_type.push('Review::Initial') if ia_statuses.length > 0
        cs_statuses = status_selected(MppCaseSearch::CS_FILTERS, fparams, 'cs_')
        # no_review status overrides all other statuses
        if ia_statuses.include? 'no_review'
          no_review = true
          review_type = []
          ia_statuses = []
          cs_statuses = []
        end
        cases = CasesV2Search.new.search(fparams["search"], @current_page, MAX_SEARCH_RESULTS,
          { program: 'MPP',
            review_type: review_type,
            review_status: ia_statuses,
            no_review: no_review,
            certificate_status: cs_statuses,
            case_owner: fparams["case_owner"]
          }).order(get_sort_order(fparams, 'MPP')).paginate(page: @current_page, per_page: MAX_SEARCH_RESULTS)
          #@all_cases = CasesV2Search.new.search(fparams["search"], 0, cases.total,
          #                                 { program: 'MPP',
          #                                   review_type: review_type,
          #                                   review_status: ia_statuses,
          #                                   no_review: no_review,
          #                                   certificate_status: cs_statuses,
          #                                   case_owner: fparams["case_owner"]
          #                                 })
          session[:download_ids] = cases.collect(&:id).map(&:to_i)
          session[:program] = @program
          cases
        end

        def get_wosb_cases(fparams)
          program_type = []
          program_type.push('EDWOSB') unless fparams["edwosb"] == "0"
          program_type.push('WOSB') unless fparams["wosb"] == "0"
          program_type = ['WOSB','EDWOSB'] unless program_type.any?
          no_review = false
          review_type = []
          ia_statuses = status_selected(WosbCaseSearch::IA_FILTERS, fparams, 'ia_')
          cs_statuses = status_selected(WosbCaseSearch::CS_FILTERS, fparams, 'cs_')
          as_statuses = status_selected(WosbCaseSearch::AS_FILTERS, fparams, 'as_')
          cases = CasesV2Search.new.search(fparams["search"], @current_page, MAX_SEARCH_RESULTS,
            { program: program_type,
              review_type: review_type,
              no_review: no_review,
              review_status: ia_statuses,
              certificate_status: cs_statuses,
              application_status: as_statuses,
              case_owner: fparams["case_owner"],
              current_reviewer: fparams["current_reviewer"],
            }).order(get_sort_order(fparams, 'WOSB')).paginate(page: @current_page, per_page: MAX_SEARCH_RESULTS)
            session[:download_ids] = cases.collect(&:id).map(&:to_i)
            session[:program] = @program
            cases
          end

          def eight_a_role_path
            hash_params = Hash[EightACaseSearch::PARAMS_MAP.zip]
            string_params = Hash[hash_params.map{|k,v| ["eight_a[#{k}]",'0']}]
            eight_a_sba_analyst_cases_path(string_params.merge({'eight_a[sort]': 'asc'}))
          end

          def mpp_role_path
            hash_params = Hash[MppCaseSearch::PARAMS_MAP.zip]
            string_params = Hash[hash_params.map{|k,v| ["mpp[#{k}]",'0']}]
            mpp_sba_analyst_cases_path(string_params.merge({'mpp[sort]': 'asc'}))
          end

          def wosb_role_path
            # wosb_sba_analyst_cases_path({'wosb[sort]': 'asc', 'wosb[wosb]': 'wosb', 'wosb[edwosb]': 'edwosb'})
            hash_params = Hash[WosbCaseSearch::PARAMS_MAP.zip]
            string_params = Hash[hash_params.map{|k,v| ["wosb[#{k}]",'0']}]
            wosb_sba_analyst_cases_path(string_params.merge({'wosb[sort]': 'asc'}))
          end

          def status_selected(filters, fparams, param_prefix)
            # get array of selected status
            selected = []
            filters.each do |element|
              selected.push(fparams[element]&.gsub(param_prefix, '')) unless fparams[element] == "0"
            end
            selected
          end

          def get_sort_order(fparams, program)
            return {firm_name_sort: :asc} if fparams["sort"] == 'Firm name: Ascending'
            return {firm_name_sort: :desc} if fparams["sort"] == 'Firm name: Descending'
            case program
            when 'EIGHT_A'
              return {'submit_date_eight_a': :asc} if fparams["sort"] == 'Date submitted: Oldest First'
              return {'submit_date_eight_a': :desc} if fparams["sort"] == 'Date submitted: Newest First'
              return {'certificate_start_date_eight_a': :asc} if fparams["sort"] == 'Program start date: Earliest'
              return {'certificate_start_date_eight_a': :desc} if fparams["sort"] == 'Program start date: Latest'
            when 'MPP'
              return {'submit_date_mpp': :asc} if fparams["sort"] == 'Date submitted: Oldest First'
              return {'submit_date_mpp': :desc} if fparams["sort"] == 'Date submitted: Newest First'
            when 'WOSB'
              return {'submit_date_wosb': :asc} if fparams["sort"] == 'Date submitted: Oldest First'
              return {'submit_date_wosb': :desc} if fparams["sort"] == 'Date submitted: Newest First'
            end
            nil
          end

          def create_sort_options
            @sort_options = [
              { name: "Sort by...", value: ""  },
              { name: "Relevance", value: ""  },
              { name: "Firm name: Ascending", value: "Firm name: Ascending"},
              { name: "Firm name: Descending", value: "Firm name: Descending" },
              { name: "Date submitted: Oldest First", value: "Date submitted: Oldest First"},
              { name: "Date submitted: Newest First", value: "Date submitted: Newest First"},
              { name: "Program start date: Earliest", value: "Program start date: Earliest"},
              { name: "Program start date: Latest", value: "Program start date: Latest"}
            ]
          end
        end
      end
