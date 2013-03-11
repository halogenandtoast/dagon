module Dagon
  module AST
    class VarRefNode < Node
      attr_reader :variable_name
      def initialize filename, line_number, variable_name
        super filename, line_number
        @variable_name = variable_name
      end

      def evaluate interpreter
        interpreter.notify(self)
        if interpreter.frame.local_variable? @variable_name
          interpreter.frame[@variable_name]
        else
          interpreter.frame.object.dagon_send(interpreter, @variable_name)
        end
      end
    end
  end
end
