module Dagon
  module Ast
    class Node
      attr_reader :filename, :line_number
      def initialize file_name, line_number
        @filename = file_name
        @line_number = line_number
      end

      def execute_list interpreter, nodes
        nodes.map { |node| interpreter.evaluate(node) }.last
      end

      def error string
        scope.error string
      end

    end
  end
end
