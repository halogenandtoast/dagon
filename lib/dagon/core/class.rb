module Dagon
  module Core
    class Class
      def initialize name, block, scope
        @name = name
        @block = block
        @scope = scope
      end
    end
  end
end
