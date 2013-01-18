module Dagon
  class DString < DObject
    def +(string)
      if string.is_a? DString
        DString.new(value + string.value)
      else
        raise ArgumentError
      end
    end
  end
end
