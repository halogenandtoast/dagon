module Dagon
  module AST
    class CaseNode < Node
      def initialize filename, line_number, matcher, statements
        super filename, line_number
        @matcher = matcher
        @statements = statements
      end

      def evaluate interpreter
        execute_list interpreter, @statements
      end

      def matcher(interpreter)
        @matcher.evaluate(interpreter)
      end
    end
  end
end
