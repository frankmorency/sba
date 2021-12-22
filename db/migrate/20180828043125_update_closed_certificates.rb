class UpdateClosedCertificates < ActiveRecord::Migration
  def change
    # This will close certificates with a closed review and update the All Cases index
    Certificate.joins(sba_applications: :reviews).where('reviews.workflow_state = ?', 'closed').update_all(workflow_state: 'closed')
  end
end
