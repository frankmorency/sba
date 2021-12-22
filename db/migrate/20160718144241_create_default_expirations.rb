class CreateDefaultExpirations < ActiveRecord::Migration
  def change
    ExpirationDate.create!(model: 'AccessRequest', field: 'request_expires_on', days_from_now: 7)
    ExpirationDate.create!(model: 'AccessRequest', field: 'access_expires_on', days_from_now: 90)
  end
end
