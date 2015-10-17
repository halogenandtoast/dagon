module Dagon
  module AST
    class CaseStatementNode < Node
      def initialize filename, line_number, expression, cases
        super filename, line_number
        @expression = expression
        @cases = cases
      end

      def evaluate interpreter
        value = @expression.evaluate(interpreter)
        case_to_run = matching_case(interpreter, value)
        case_to_run.evaluate(interpreter)
      end

      private

      def matching_case(interpreter, value)
        @cases.find do |current_case|
          current_case.matcher(interpreter) == value
        end
      end
    end
  end
end
