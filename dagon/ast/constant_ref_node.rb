module Dagon
  module AST
    class ConstantRefNode < Node
      attr_reader :variable_name
      def initialize filename, line_number, variable_name
        super filename, line_number
        @constant_name = variable_name
      end

      def evaluate interpreter
        interpreter.current_object.dagon_const_get(@constant_name)
      end
    end
  end
end
