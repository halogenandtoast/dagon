module Dagon
  module Ast
    class InstanceInitNode < Node
      def initialize filename, line_number, klass_name, arguments
        super filename, line_number
        @klass_name = klass_name
        @arguments = arguments
      end

      def evaluate interpreter
        arguments = @arguments.map { |argument| argument.evaluate interpreter }
        object = interpreter.frame.object
        klass = object.dagon_const_get(@klass_name)
        klass.dagon_send(:new)
      end
    end
  end
end
