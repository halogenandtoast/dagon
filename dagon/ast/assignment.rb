module Dagon
  module Ast
    class Assignment
      def initialize name, value, scope
        @name = name
        @value = value
        @scope = scope
      end

      def define
        @scope.define(@name, @value)
      end
    end
  end
end
