module Sectionable
  extend ActiveSupport::Concern

  included do
    belongs_to  :root_section, class_name: 'Section::Root'
    belongs_to  :first_section, class_name: 'Section'
  end

  def section_debug
    sections.map(&:name).sort
  end

  def section_rule_debug
    section_rules.map(&:debug).join
  end

  def get_section(path)
    tree = path.split("/").delete_if {|element| element == '' }
    node = tree.pop

    path = tree.map do |name|
      every_section.find_by(name: name).id
    end.join("/")
    path = nil if path == ''

    sections.find_by(ancestry: path, name: node)
  end
end
