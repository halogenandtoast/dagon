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
    end
  end
end
