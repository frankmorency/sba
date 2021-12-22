module DataUpdates
  class Base
    attr_accessor :commit

    def initialize
      @commit = true
    end

    def update!
    end
  end
end