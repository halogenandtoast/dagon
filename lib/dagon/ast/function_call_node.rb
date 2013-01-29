module Dagon
  module Ast
    class DagonError < StandardError; end
    class DagonArgumentError < DagonError; end

    class FunctionCallNode < Node
      def initialize filename, line_number, function_name, arguments
        super filename, line_number
        @function_name = function_name
        @arguments = arguments
      end

      def evaluate interpreter
        arguments = @arguments.map { |argument| argument.evaluate interpreter }
        begin
          interpreter.call_dagon_function_or(@function_name, arguments) {
            if arguments.empty? or not arguments[0].respond_to?(@function_name)
              interpreter.call_ruby_toplevel_or(@function_name, arguments) {
                dagon_error! "Undefined function #{@function_name.to_s}"
              }
            else
              receiver = arguments.shift
              receiver.send @function_name, *arguments
            end
          }
        rescue DagonArgumentError, ArgumentError
          binding.pry
          dagon_error! $!.message
        end
      end
    end
  end
end
