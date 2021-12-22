class AnonymousUser < ActiveRecord::Base
  include Answerable

  acts_as_paranoid

  has_many      :answers, as: :owner
end
