class AgencyNaicsCode < ActiveRecord::Base
  if Feature.active?(:elasticsearch)
    update_index('agency_requirements') { agency_requirements }
  end

  strip_attributes
  acts_as_paranoid

  has_many  :agency_requirements

  validates :code, presence: true, uniqueness: {case_sensitive: false}

  def size
    if size_employees
      "#{size_employees} Employees"
    elsif size_dollars_mm
      "#{size_dollars_mm} M"
    end
  end
end