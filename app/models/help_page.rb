class HelpPage < ActiveRecord::Base
  include ActiveModel::Validations

  has_paper_trail

  validate :check_tags_white_list

  def check_tags_white_list
    white_list_tags = ["html", "body", "section", "p", "div", "span", "strong", "hr", "a", "s", "em", "img", "b", "ul", "li", "br"]
    feilds_to_check.each do |feild|
      doc = Nokogiri.HTML(self.public_send(feild))
      tags_in_element = doc.search("*").map(&:name)
      result = (tags_in_element - white_list_tags)
      result.each do |tag|
        errors.add(feild.to_sym, " Invalid - #{tag} - Entered.")
      end
    end
  end

  def feilds_to_check
    ["left_panel", "right_panel", "title"]
  end
end
