module Dagon
  module Ast
    class LiteralNode < Node
      def initialize filename, line_number, literal
        super filename, line_number
        @value = literal
      end

      def evaluate interpreter
        @value
      end
    end
  end
end
