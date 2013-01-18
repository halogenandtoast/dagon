module Dagon
  class DArray < DObject
    def initialize(values_array)
      @value = []
      if values_array[0] == :values
        values_array[1].each do |type, value|
          case type
          when :integer
            @value << DInteger.new(value)
          when :string
            @value << DString.new(value)
          when :array
            DArray.new(member)
          end
        end
      end
    end

    def to_s
      "[" << value.map(&:to_s).join(', ') << "]"
    end
  end
end
