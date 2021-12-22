class Program < ActiveRecord::Base
  include NameRequirements

  DISPLAY_ORDER = %w(eight_a wosb mpp)

  acts_as_paranoid
  has_paper_trail

  has_many :groups
  has_many :questionnaires
  has_many :business_units
  has_many :agency_requirements

  def eight_a?
    name == "eight_a"
  end

  def mpp?
    name == "mpp"
  end


  def self.display_list
    DISPLAY_ORDER.map { |name| Program.find_by(name: name) }
  end

  def teaser
    case name
    when "eight_a"
      "The <b>8(a) Business Development (BD) Program</b> offers a broad scope of assistance to firms that are owned and controlled at least 51% socially and economically disadvantaged individual(s).".html_safe
    # when "wosb"
    #   "The <b>Women-Owned Small Business (WOSB)</b> Federal Contract Program allows set-asides for WOSBs in industries where firms are underrepresented. WOSBs must be at least 51% owned and controlled by women.".html_safe
    when "mpp"
      "The purpose of the new program is to develop strong protégé firms through mentor-provided business development assistance, and to help protégés successfully compete for government contracts.".html_safe
    when "asmpp"
      "The All Small Mentor-Protégé program (ASMPP) allows small businesses and experienced government contractors to partner in mentor-protégé relationships and compete for set-aside contracts together.".html_safe
    end
  end
end
