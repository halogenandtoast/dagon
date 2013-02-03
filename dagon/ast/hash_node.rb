require 'core/hash'

module Dagon
  module AST
    class HashNode < Node
      def initialize(filename, line_number, assignments)
        super(filename, line_number)
        @assignments = assignments
      end

      def evaluate(interpreter)
        interpreter.get_class("Hash").dagon_new(interpreter, @assignments)
      end
    end
  end
end
