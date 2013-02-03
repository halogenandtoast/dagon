require "core/block"

module Dagon
  module AST

    class BlockNode < Node
      def initialize filename, line_number, statements, arguments
        super filename, line_number
        @statements = statements
        @arguments = arguments
      end

      def evaluate interpreter
        arguments = @arguments.map(&:variable_name)
        interpreter.get_class("Block").dagon_send(interpreter, "new", @statements, interpreter.frame, arguments)
      end
    end
  end
end
