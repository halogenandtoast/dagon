module Dagon
  module AST
    class CurriedFunctionCallNode < Node

      def initialize filename, line_number, function, arguments, block
        super filename, line_number
        @function = function
        @arguments = arguments
        @block = block
      end

      def evaluate interpreter
        arguments = @arguments.map { |argument| argument.evaluate interpreter }
        if @block
          arguments << @block.evaluate(interpreter)
        end
        @function.evaluate(interpreter).call(interpreter, *arguments)
      end
    end
  end
end
