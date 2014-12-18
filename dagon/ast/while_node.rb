module Dagon
  module AST
    class WhileNode < Node
      def initialize filename, line_number, condition, statements
        super filename, line_number
        @condition = condition
        @statements = statements
      end

      def evaluate interpreter
        until [Dfalse, Dvoid].include? @condition.evaluate(interpreter)
          execute_list interpreter, @statements
        end
      end
    end
  end
end
