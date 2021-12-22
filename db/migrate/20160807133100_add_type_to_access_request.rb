class AddTypeToAccessRequest < ActiveRecord::Migration
  def change
    add_column :access_requests, :type, :string         # Changing table to be able to us STI.

    # updating the database to new CoAccessRequest
    AccessRequest.all.each do |req|
      req.type = "VendorProfileAccessRequest"
      req.save!
    end

  end
end
