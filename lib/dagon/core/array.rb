module Dagon
  module Core
    class Array < Dagon::Core::Object
      def initialize(values_array)
        @value = []
        if values_array[0] == :values
          values_array[1].each do |type, value|
            case type
            when :integer
              @value << Dagon::Core::Integer.new(value)
            when :string
              @value << Dagon::Core::String.new(value)
            when :array
              Dagon::Core::Array.new(member)
            end
          end
        end
      end

      def to_s
        "[" << value.map(&:to_s).join(', ') << "]"
      end
    end
  end
end
