module Dagon
  module Ast
    class VarRefNode < Node
      attr_reader :variable_name
      def initialize filename, line_number, variable_name
        super filename, line_number
        @variable_name = variable_name
      end

      def evaluate interpreter
        if interpreter.frame.local_variable? @variable_name
          interpreter.frame[@variable_name]
        else
          interpreter.call_function_or(@variable_name, []) {
            dagon_error! "unknown method or local variable #{@variable_name.to_s}"
          }
        end
      end
    end
  end
end
