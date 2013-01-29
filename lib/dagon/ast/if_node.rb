module Dagon
  module Ast
    class IfNode < Node
      def initialize filename, line_number, condition, true_statements, false_statements
        super filename, line_number
        @condition = condition
        @true_statements = true_statements
        @false_statements = false_statements
      end

      def evaluate interpreter
        if @condition.evaluate interpreter
          execute_list interpreter, @true_statements
        else
          execute_list interpreter, @false_statements
        end
      end
    end
  end
end
