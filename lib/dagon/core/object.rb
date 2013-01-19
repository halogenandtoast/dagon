module Dagon
  module Core
    class Object
      attr_reader :value, :binding
      def initialize value
        @value = value
        @binding = Dagon::Core::Scope.new(self)
      end

      def to_s
        value
      end
    end
  end
end
