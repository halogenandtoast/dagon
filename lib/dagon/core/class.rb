module Dagon
  module Core
    class Class
      def initialize name, block, scope
        @name = name
        @block = block
        @scope = Dagon::Core::Scope.new(self, scope)
      end

      def binding
        @scope
      end
    end
  end
end
