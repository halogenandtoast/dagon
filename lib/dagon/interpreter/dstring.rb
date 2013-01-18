module Dagon
  class DString < DObject
    def initialize value
      @value = eval("\"#{value}\"")
    end

    def +(string)
      if string.is_a? DString
        DString.new(value + string.value)
      else
        raise ArgumentError
      end
    end
  end
end
