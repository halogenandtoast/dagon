module Dagon
  module Ast
    class DagonError < StandardError; end
    class DagonArgumentError < DagonError; end

    class FunctionCallNode < Node
      def initialize filename, line_number, object, function_name, arguments
        super filename, line_number
        @function_name = function_name
        @arguments = arguments
        @object = object
      end

      def evaluate interpreter
        arguments = @arguments.map { |argument| argument.evaluate interpreter }
        object = if @object
                   @object.evaluate interpreter
                 else
                   interpreter.frame.object
                 end
        object.dagon_send interpreter, @function_name, *arguments
      end
    end
  end
end
