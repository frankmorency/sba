class Note < ActiveRecord::Base
  LENGTH = 100
  acts_as_paranoid
  has_paper_trail

  belongs_to :author, class_name: "User"
  belongs_to :notated, polymorphic: true

  def self.published
    where(published: true)
  end

  def short?
    body.nil? || body.length <= LENGTH
  end
end
