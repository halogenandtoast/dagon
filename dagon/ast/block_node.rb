require "core/block"

module Dagon
  module AST

    class BlockNode < Node
      def initialize filename, line_number, statements
        super filename, line_number
        @statements = statements
      end

      def evaluate interpreter
        Dagon::Core::DG_Block_Class.new.dagon_send(interpreter, "new", @statements, interpreter.frame)
      end
    end
  end
end
