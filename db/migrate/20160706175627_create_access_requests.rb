class CreateAccessRequests < ActiveRecord::Migration
  def change
    # The access requests table tracks access requests by contracting officers to review a specific organization
    create_table :access_requests do |t|
      t.references :user, index: true   # the CO making the request
      t.references :organization, index: true # the org they're requesting access to
      t.text :solicitation_number, index: true # the solicitation number - ask mary
      t.text :solicitation_naics, index: true # the solicitation naics - ask mary
      t.text :procurement_type # the procurement type - ask mary
      t.text :status, index: true # the status of the request - see the access_request.rb model for possible values
      t.date  :accepted_on # the date the request was accepted
      t.date  :request_expires_on, index: true # the date the request expires
      t.date  :access_expires_on, index: true # the date the access itself expires
      t.datetime  :deleted_at

      t.timestamps null: false
    end
  end
end
