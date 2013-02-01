module Dagon
  module Core
    class String < Dagon::Core::Object
      def +(string)
        if string.is_a? Dagon::Core::String
          Dagon::Core::String.new(value + string.value)
        else
          raise ArgumentError
        end
      end

      def equal string
        if value == string.value
          Dagon::Core::True.instance
        else
          Dagon::Core::False.instance
        end
      end

      def not_equal string
        if value != string.value
          Dagon::Core::True.instance
        else
          Dagon::Core::False.instance
        end
      end
    end
  end
end
