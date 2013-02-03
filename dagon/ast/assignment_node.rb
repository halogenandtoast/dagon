module Dagon
  module AST
    class AssignmentNode < Node
      def initialize filename, line_number, variable_name, value
        super filename, line_number
        @variable_name = variable_name
        @value = value
      end

      def evaluate interpreter
        interpreter.frame[@variable_name] = @value.evaluate(interpreter)
      end
    end
  end
end