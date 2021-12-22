class FixAdhocNaming < ActiveRecord::Migration
  def change
    
    Questionnaire.where(name: %w(adhoc_text_and_attachment adhoc_attachment adhoc_text)).each do |q|
      q.update_attributes review_page_display_title: 'Additional Information Request', title: 'Additional Information Request'
    end
  end
end
