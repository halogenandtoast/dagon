module Dagon
  module Core
    class String < Dagon::Core::Object
      def initialize value
        @value = value
      end

      def +(string)
        if string.is_a? Dagon::Core::String
          Dagon::Core::String.new(value + string.value)
        else
          raise ArgumentError
        end
      end
    end
  end
end
