module Dagon
  class DString < DObject
    def +(string)
      if string.is_a? DString
        DString.new(value + string)
      else
        raise ArgumentError
      end
    end
  end
end
