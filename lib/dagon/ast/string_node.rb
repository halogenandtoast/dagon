module Dagon
  module Ast
    class StringNode < Node
      def initialize filename, line_number, string
        super filename, line_number
        @value = string
      end

      def evaluate interpreter
        @value.dup
      end
    end
  end
end
