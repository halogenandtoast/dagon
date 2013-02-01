module Dagon
  module Core
    class Integer < Dagon::Core::Object
      def + object
        self.class.new(value + object.value)
      end

      def - object
        self.class.new(value - object.value)
      end

      def * object
        self.class.new(value * object.value)
      end

      def / object
        self.class.new(value / object.value)
      end

      def ** object
        self.class.new(value ** object.value)
      end

      def equal object
        if value == object.value
          Dagon::Core::True.instance
        else
          Dagon::Core::False.instance
        end
      end

      def times &block
        self.value.times &block
      end
    end
  end
end
