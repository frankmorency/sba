module NameRequirements
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true, uniqueness: true, format: /\A\w+\Z/
    validates :title, presence: true

    before_validation :set_title, on: :create
  end

  def to_param
    name
  end

  def set_title
    if title.blank?
      self.title = name && name.split('_').map(&:upcase).join(' ')
    end
  end

  module ClassMethods
    def get!(name)
      get(name) || raise("Unable to find question: #{name}") 
    end

    def get(name)
      find_by(name: name.to_s)
    end
  end
end
