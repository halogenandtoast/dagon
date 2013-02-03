module Dagon
  module AST
    class Node
      attr_reader :filename, :line_number
      def initialize filename, line_number
        @filename = filename
        @line_number = line_number
      end

      def execute_list interpreter, nodes
        nodes.map do |node|
          node.evaluate(interpreter)
        end.last
      end

      def dagon_error! string
        raise DagonError, "Problem? #{string}"
      end

    end
  end
end