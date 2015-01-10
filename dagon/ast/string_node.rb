module Dagon
  module AST
    class StringNode < Node
      def initialize filename, line_number, string
        super filename, line_number
        @value = string
      end

      def inspect
        "<string##{@value.inspect}>"
      end

      def evaluate interpreter
        interpreter.string(@value)
      end
    end
  end
end
