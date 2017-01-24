module Funky
  class FunkyObject
    extend DataParser

    attr_reader :data

    def initialize(data)
      @data = data
    end

    # @return [String] the object ID.
    def id
      data[:id]
    end
  end
end
