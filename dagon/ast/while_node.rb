module Dagon
  module AST
    class WhileNode < Node
      def initialize filename, line_number, condition, statements
        super filename, line_number
        @condition = condition
        @statements = statements
      end

      def evaluate interpreter
        result = Dfalse
        while @condition.evaluate(interpreter) != Dfalse
          result = execute_list(interpreter, @statements)
        end
        result
      end
    end
  end
end
