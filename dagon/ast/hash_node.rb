require 'core/hash'

module Dagon
  module AST
    class HashNode < Node
      def initialize(filename, line_number, assignments)
        super(filename, line_number)
        @assignments = assignments
      end

      def evaluate(interpreter)
        hash = {}
        @assignments.each do |assignment|
          value = assignment.variable_value.evaluate(interpreter)
          hash[assignment.variable_name] = value
        end
        interpreter.get_class("Hash").dagon_new(interpreter, hash)
      end
    end
  end
end
