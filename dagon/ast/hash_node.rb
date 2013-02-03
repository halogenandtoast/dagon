require 'core/hash'

module Dagon
  module AST
    class HashNode < Node
      def initialize(filename, line_number, assignments)
        super(filename, line_number)
        @assignments = assignments
      end

      def evaluate(interpreter)
        Dagon::Core::DG_HashClass.new.dagon_send(interpreter, "new", @assignments)
      end
    end
  end
end
