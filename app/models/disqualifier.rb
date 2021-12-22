class Disqualifier < ActiveRecord::Base
  has_many :question_presentations

  validates :value, presence: true
  validates :message, presence: true
end
