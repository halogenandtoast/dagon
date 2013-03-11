require 'core/array'

module Dagon
  module AST
    class ArrayNode < Node
      def initialize filename, line_number, list
        super filename, line_number
        @list = list
      end

      def evaluate interpreter
        evaluated_list = @list.map { |item| item.evaluate(interpreter) }
        interpreter.array(evaluated_list)
      end
    end
  end
end
