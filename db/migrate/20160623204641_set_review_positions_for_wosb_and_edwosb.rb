class SetReviewPositionsForWosbAndEdwosb < ActiveRecord::Migration
  def change
    i = 0
    Section.where({sba_application_id: nil, name: '8a'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'third_party_cert_part_1'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'third_party_cert_part_2'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'third_party_cert_part_3'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'corp1'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'corp2'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'corp3'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'corp4'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'corp5'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'partnership'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'llc'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'operations_part_1'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'operations_part_2'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'operations_part_3'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'operations_part_4'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'operations_part_5'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'operations_part_6'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'edwosb_section_1'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'edwosb_section_2'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'edwosb_section_3'}).update_all review_position: (i += 1)
    Section.where({sba_application_id: nil, name: 'edwosb_section_4'}).update_all review_position: (i += 1)
  end
end
