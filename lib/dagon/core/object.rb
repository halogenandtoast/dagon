module Dagon
  module Core
    class Object
      attr_reader :value
      def initialize value
        @value = value
      end

      def to_s
        value
      end

      def > other
        if value > other.value
          Dagon::Core::True.instance
        else
          Dagon::Core::False.instance
        end
      end

      def < other
        if value < other.value
          Dagon::Core::True.instance
        else
          Dagon::Core::False.instance
        end
      end

      def >= other
        if value >= other.value
          Dagon::Core::True.instance
        else
          Dagon::Core::False.instance
        end
      end

      def <= other
        if value < other.value
          Dagon::Core::True.instance
        else
          Dagon::Core::False.instance
        end
      end

      def equal other
        if value == other.value
          Dagon::Core::True.instance
        else
          Dagon::Core::False.instance
        end
      end

      def not_equal other
        if value != other.value
          Dagon::Core::True.instance
        else
          Dagon::Core::False.instance
        end
      end
    end
  end
end
