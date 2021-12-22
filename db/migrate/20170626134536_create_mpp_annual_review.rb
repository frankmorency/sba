class CreateMppAnnualReview < ActiveRecord::Migration
  def change
    
    DocumentType.create! name: 'MPP Annual Report'
    cert_type = CertificateType.get('mpp')

    mpp_r = Questionnaire::SimpleQuestionnaire.create! name: 'mpp_annual_renewal', title: 'MPP Annual Report', anonymous: false, program: Program.get('mpp'), link_label: 'MPP Application'

    mpp_r.create_sections! do
      root 'mpp_annual_renewal', 1, title: 'MPP Annual Report' do
        question_section 'mpp_renewal_upload', 0, title: 'MPP Document Upload', first: true do
          null_with_attachment_required 'mpp_annual_review', 1, title: 'Please upload the completed, signed <a href="/mpp_annual_evaluation_pdf/SBA_ASMPP_AER_July_2017_Final.pdf" target="_blank">ALL-SMALL MENTOR/PROTEGE PROGRAM ANNUAL EVALUATION REPORT FOR PROTEGES</a> form.', document_types: 'MPP Annual Report'
        end
        review_section 'review', 3, title: 'Review', submit_text: 'Submit'
        signature_section 'signature', 4, title: 'Signature', submit_text: 'Accept'
      end
    end

    mpp_r.create_rules! do
      section_rule 'mpp_renewal_upload', 'review'
      section_rule 'review', 'signature'
    end

    Section.where(questionnaire_id: Questionnaire.get('mpp_annual_renewal').id, name: 'signature').update_all is_last: true

    CurrentQuestionnaire.create!(questionnaire: mpp_r, certificate_type: cert_type, kind: SbaApplication::ANNUAL_REVIEW)

    cert_type.initial_questionnaire.update_attributes scheduler_can_start: true
    cert_type.update_attributes renewal_period_in_days: 365, renewal_notification_period_in_days: 60
  end
end
