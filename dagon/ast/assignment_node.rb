module Dagon
  module AST
    class AssignmentNode < Node
      def initialize filename, line_number, variable_name, value
        super filename, line_number
        @variable_name = variable_name
        @value = value
      end

      def evaluate interpreter
        if @variable_name =~ /^@/
          interpreter.frame.object.set_instance_variable(@variable_name, @value.evaluate(interpreter))
        else
          interpreter.frame[@variable_name] = @value.evaluate(interpreter)
        end
      end
    end
  end
end
