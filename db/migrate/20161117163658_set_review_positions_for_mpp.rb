class SetReviewPositionsForMpp < ActiveRecord::Migration
  def change
    i = 0
    Section.where({sba_application_id: nil, name: 'eight_a_participants'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'eligibility'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'naics_code'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'size_determination'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'size_redetermination'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'redetermination_info'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'protege_training'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'protege_general_biz'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'protege_active_agreements'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'protege_active_agreement_docs'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'mpp_agreement'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'protege_general_needs'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'management_and_tech'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'financial'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'contracting'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'trade_education'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'business_dev'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'general_admin'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'mentor_training'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'mentor_business_info'}).update_all review_position: (i += 1)
  end
end
