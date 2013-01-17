module Dagon
  class DInteger < DObject
    def + object
      DInteger.new(value + object.value)
    end

    def - object
      DInteger.new(value - object.value)
    end

    def * object
      DInteger.new(value * object.value)
    end

    def / object
      DInteger.new(value / object.value)
    end

    def ** object
      DInteger.new(value ** object.value)
    end
  end
end
