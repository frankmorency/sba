class App1477 < ActiveRecord::Migration
  def change

    
    q = Question.find_by(name: 'mpp_annual_review')
    q.update_attribute('title', '<p>There are two components to the annual reporting requirement. These documents are fillable .pdf documents that you will download and complete. You can download these documents below:</p><ol><li> <a href="/mpp_annual_evaluation_pdf/SBA_ASMPP_AER_July_2017_Final.pdf" target="_blank">Protégé Report (PDF)</a></li><li> <a href="/mpp_annual_evaluation_pdf/SBA_ASMPP_AER_July_2017_MentorAddendum.pdf" target="_blank">Mentor Report (PDF)</a></li> </ol> <p>The Mentor report should be prepared by the Mentor, signed, and returned to the Protégé. The Protégé should complete and sign the Protégé report; and upload both the signed Mentor report and the Protégé signed report separately into the Certify.SBA.gov portal by returning to this page and using the "Add required documents" link below.</p>')
    q.save!

  end
end
