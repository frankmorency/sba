class EightACaseSearch
  include ActiveModel::Model
  AR_FILTERS = [ :ar_screening, :ar_returned_with_deficiency_letter, :ar_processing, :ar_retained, :ar_voluntary_withdrawal_recommended, :ar_early_graduation_recommended, :ar_termination_recommended ]
  IA_FILTERS = [ :ia_appeal_intent, :ia_screening, :ia_returned_with_15_day_letter, :ia_closed, :ia_processing, :ia_sba_declined, :ia_pending_reconsideration, :ia_pending_reconsideration_or_appeal, :ia_reconsideration, :ia_appeal, :ia_sba_approved ]
  CS_FILTERS = [ :cs_pending, :cs_ineligible, :cs_active, :cs_graduated, :cs_early_graduated, :cs_terminated, :cs_withdrawn, :cs_expired, :cs_bdmis_rejected ]
  AA_FILTERS = [ :ar_voluntary_withdrawal_recommended, :ar_early_graduation_recommended, :ar_termination_recommended]
  PARAMS_MAP = AR_FILTERS + IA_FILTERS + CS_FILTERS + AA_FILTERS

  attr_accessor :ar_screening, :ar_returned_with_deficiency_letter, :ar_processing, :ar_retained, :ar_early_graduation_recommended, :ar_termination_recommended, :ar_voluntary_withdrawal_recommended,
                :ia_appeal_intent, :ia_screening, :ia_returned_with_15_day_letter, :ia_closed, :ia_processing, :ia_sba_declined, :ia_pending_reconsideration, :ia_pending_reconsideration_or_appeal, :ia_reconsideration, :ia_appeal, :ia_sba_approved,
          :cs_pending, :cs_ineligible, :cs_active, :cs_graduated, :cs_early_graduated, :cs_terminated, :cs_withdrawn, :cs_expired, :cs_bdmis_rejected,
  				:case_owner, :service_bos, :search, :sort, :sba_office, :start_date, :end_date
end
