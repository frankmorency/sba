class ProperlyLinkVendorAdminSectionOfAnnualReviews < ActiveRecord::Migration
  def change
    SbaApplication::EightAAnnualReview.all.each do |ar|
      if ar.first_section.sub_application_id
        ar.sections.find_by(name: 'vendor_admin').children.find_by(name: 'contributor_va_eight_a_disadvantaged_individual').update_attribute(:sub_application_id, ar.first_section.sub_application_id)
        ar.first_section.update_attribute(:sub_application_id, nil)
      end
    end
  end
end
