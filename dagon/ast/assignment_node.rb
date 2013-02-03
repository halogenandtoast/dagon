module Dagon
  module AST
    class AssignmentNode < Node
      attr_reader :variable_name
      attr_reader :variable_value
      def initialize filename, line_number, variable_name, value
        super filename, line_number
        @variable_name = variable_name
        @variable_value = value
      end

      def evaluate interpreter
        if variable_name[0] == "@"
          interpreter.frame.object.set_instance_variable(variable_name, value.evaluate(interpreter))
        else
          interpreter.frame[variable_name] = variable_value.evaluate(interpreter)
        end
      end
    end
  end
end
