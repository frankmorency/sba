class WosbCaseSearch
  include ActiveModel::Model

  IA_FILTERS = [ :ia_no_review, :ia_assigned_in_progress, :ia_returned_for_modification, :ia_recommend_eligible, :ia_recommend_ineligible, :ia_determination_made ]
  CS_FILTERS = [ :cs_ineligible, :cs_active, :cs_expired ]
  AS_FILTERS = [ :as_sba_approved, :as_third_party_certified, :as_self_certified ]
  PARAMS_MAP = IA_FILTERS + CS_FILTERS + AS_FILTERS


  attr_accessor :edwosb, :wosb,
  :ia_assigned_in_progress, :ia_returned_for_modification, :ia_recommend_eligible, :ia_recommend_ineligible, :ia_determination_made, :ia_no_review,
  :cs_pending, :cs_ineligible, :cs_active, :cs_graduated, :cs_early_graduated, :cs_terminated, :cs_withdrawn, :cs_expired, :as_sba_approved,
  :as_third_party_certified, :as_self_certified,
  :case_owner, :current_reviewer, :search, :sort

end
