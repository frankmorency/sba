class ExpirationDate < ActiveRecord::Base
  validates :model, presence: true
  validates :field, presence: true

  validates :days_from_now, presence: true

  def self.get(klass, field)
    find_by(model: klass.to_s, field: field).try(:days_from_now)
  end
end
