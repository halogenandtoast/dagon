module Dagon
  module Core
    class Object
      attr_reader :value, :scope
      def initialize value
        @value = value
        @scope = Dagon::Core::Scope.new(self)
      end

      def to_s
        value
      end
    end
  end
end
