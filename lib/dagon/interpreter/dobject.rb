module Dagon
  class DObject
    attr_reader :value
    def initialize value
      @value = value
    end

    def to_s
      value
    end

    def reduce
      self
    end

    def greater_than(other)
      if value > other.value
        DTrue.new
      else
        DFalse.new
      end
    end

    def less_than(other)
      if value < other.value
        DTrue.new
      else
        DFalse.new
      end
    end

    def less_than_equal(other)
      if value <= other.value
        DTrue.new
      else
        DFalse.new
      end
    end

    def greater_than_equal(other)
      if value >= other.value
        DTrue.new
      else
        DFalse.new
      end
    end

    def equal(other)
      if value == other.value
        DTrue.new
      else
        DFalse.new
      end
    end

    def _if(dblock)
      DTrue.new._if(dblock)
    end
  end
end
