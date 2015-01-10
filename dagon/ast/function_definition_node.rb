module Dagon
  module AST
    class FunctionDefinitionNode < Node
      def initialize filename, line_number, function_name, function_object
        super filename, line_number
        @function_name = function_name
        @function_object = function_object
      end

      def inspect
        "<fun-def##{@function_name}>"
      end

      def evaluate interpreter
        interpreter.define_function @function_name, @function_object
      end
    end
  end
end
