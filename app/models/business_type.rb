class BusinessType < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  def self.get(name)
    find_by(name: name.to_s)
  end
end
