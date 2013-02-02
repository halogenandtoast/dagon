module Dagon
  module AST

    class UnaryFunctionCallNode < Node
      def initialize filename, line_number, object, function_name
        super filename, line_number
        @object = object
        @function_name = function_name
      end

      def evaluate interpreter
        object = @object.evaluate interpreter
        object.dagon_send interpreter, "#{@function_name}@"
      end
    end
  end
end
